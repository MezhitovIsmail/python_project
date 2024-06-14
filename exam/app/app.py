from flask import Flask, flash, redirect, render_template, request, send_from_directory, url_for
from flask_migrate import Migrate
from flask_login import login_required, current_user
import bleach
import markdown
from sqlalchemy.exc import SQLAlchemyError
import os
from models import db, Image, Book, Genre, Comment
from auth import bp as auth_bp, init_login_manager, check_perm
from comments import bp as comment_bp

app = Flask(__name__)
application = app

app.config.from_pyfile('config.py')
PER_PAGE = 10

db.init_app(app)
migrate = Migrate(app, db)

PERMITTED_PARAMS = ["name", "short_desc", "year", "pub_house", "author", "volume"]

app.register_blueprint(auth_bp)
app.register_blueprint(comment_bp)

init_login_manager(app)

from tools import ImageSaver

@app.errorhandler(SQLAlchemyError)
def handle_sqlalchemy_error(err):
    error_msg = ('Возникла ошибка при подключении к базе данных. '
                 'Повторите попытку позже.')
    return f'{error_msg} (Подробнее: {err})', 500

@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    book = db.select(Book).order_by(Book.year.desc())
    pagination = db.paginate(book, page=page, per_page=PER_PAGE)
    books = pagination.items

    return render_template('index.html', books=books, pagination=pagination)

@app.route('/images/<image_id>')
def image(image_id):
    img = db.get_or_404(Image, image_id)
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               img.storage_filename)

def params(names_list):
    result = {}
    for name in names_list:
        result[name] = request.form.get(name) or None
    return result

@app.route('/books/new')
@login_required
@check_perm("create")
def new_book():
    genres = db.session.execute(db.select(Genre)).scalars()
    return render_template('books/new.html', genres=genres, book={}, new_genres=[])

@app.route('/books/create', methods=['POST'])
@login_required
@check_perm("create")
def create_book():
    cur_params = params(PERMITTED_PARAMS)
    for param in cur_params:
        param = bleach.clean(param)
    new_genres = request.form.getlist('genre_id')
    genres = db.session.execute(db.select(Genre)).scalars()
    try:
        f = request.files.get('cover_img')
        if f and f.filename:
            img = ImageSaver(f).save()
        image_id = img.id if img else None
        book = Book(**cur_params, image_id=image_id)
        for genre in new_genres:
            new_genre = db.session.execute(db.select(Genre).filter_by(id=genre)).scalar()
            book.genres.append(new_genre)
        db.session.add(book)
        db.session.commit()
        flash(f"Книга '{book.name}' успешно добавлена", "success")
    except:
        db.session.rollback()
        flash("При сохранении возникла ошибка", "danger")
        return render_template("books/new.html", genres = genres, book=cur_params, new_genres=new_genres)
    return redirect(url_for('show', book_id=book.id))

@app.route('/delete_post/<int:book_id>', methods=['POST'])
@login_required
@check_perm('delete')
def delete_post(book_id):
    try:
        book = db.session.query(Book).filter(Book.id == book_id).scalar()
        book.genres = []
        db.session.query(Comment).filter(Comment.book_id == book_id).delete()
        count_of_images = db.session.query(Book).filter(Book.image_id == book.image_id).count()
        db.session.query(Book).filter(Book.id == book_id).delete()

        if count_of_images == 1:
            image = db.session.query(Image).filter(Image.id == book.image_id).scalar()
            db.session.query(Image).filter(Image.id == book.image_id).delete()
            os.remove(os.path.join(app.config['UPLOAD_FOLDER'], image.storage_filename))
        db.session.commit()

        return redirect(url_for('index')) 
    except:
        db.session.rollback()
        flash('Ошибка при удалении', 'danger')
    return redirect(url_for('index'))


@app.route('/books/<int:book_id>/edit', methods=['GET', 'POST'])
@login_required
@check_perm("edit")
def edit_book(book_id):
    book = db.session.query(Book).filter(Book.id == book_id).scalar()
    genres = db.session.execute(db.select(Genre)).scalars()
    edited_genres = [ str(genre.id) for genre in book.genres]

    if request.method == 'POST':
        cur_params = params(PERMITTED_PARAMS)
        for param in cur_params:
            param = bleach.clean(param)
        new_genres = request.form.getlist('genre_id')
        try:
            genres_list = []
            for genre in new_genres:
                if int(genre) != 0:
                    new_genre = db.session.execute(db.select(Genre).filter_by(id=genre)).scalar()
                    genres_list.append(new_genre)
            book.genres = genres_list
            book.name = cur_params['name']
            book.short_desc = cur_params['short_desc']
            book.year = cur_params['year']
            book.pub_house = cur_params['pub_house']
            book.author = cur_params['author']
            book.volume = cur_params['volume']
            db.session.commit()
            flash(f"Книга '{book.name}' успешно обновлена", "success")
            return redirect(url_for('show', book_id=book.id))
        except:
            db.session.rollback()
            flash("При сохранении возникла ошибка", "danger")

    return render_template("books/edit.html", genres = genres, book=book, new_genres=edited_genres)


@app.route('/books/<int:book_id>')
def show(book_id):
        try:
            book = db.session.query(Book).filter(Book.id == book_id).scalar()
            book.short_desc = markdown.markdown(book.short_desc)
            user_comment = None
            all_comments = None
            if current_user.is_authenticated:
                user_comment = db.session.query(Comment).filter(Comment.book_id == book_id).filter(Comment.user_id == current_user.id).scalar()
                if user_comment:
                    user_comment.text = markdown.markdown(user_comment.text)
                all_comments = db.session.execute(db.select(Comment).filter(Comment.book_id == book_id, Comment.user_id != current_user.id)).scalars()
            else:
                all_comments = db.session.execute(db.select(Comment).filter(Comment.book_id == book_id)).scalars()
            
            markdown_all_comments = []
            for comment in all_comments:
                markdown_all_comments.append({
                    'get_user': comment.get_user,
                    'mark': comment.mark,
                    'text': markdown.markdown(comment.text),
                    'status_id': comment.status_id
                })
            return render_template('books/show.html', book=book, comment=user_comment, all_comments=markdown_all_comments)
        except:
            flash('Ошибка при загрузке данных', 'danger')
            return redirect(url_for('index'))
