from flask import Blueprint, render_template, redirect, url_for, flash, request
from auth import check_perm
from flask_login import login_required, current_user
from models import Comment, Book, db, ReviewStatus
from flask import Blueprint
import bleach

bp = Blueprint('comments', __name__, url_prefix='/comments')

PER_PAGE = 2

@bp.route('/<int:book_id>', methods=['GET', 'POST'])
@login_required
def comment_post(book_id):
    comment = db.session.query(Comment).filter(Comment.book_id == book_id, Comment.user_id == current_user.id).scalar()
    book = db.session.query(Book).filter(Book.id == book_id).scalar()
    if comment:
        flash("Можно добавить только одну рецензию", "warning")
        return redirect(url_for('show', book_id=book_id))
    if request.method == 'POST':
        mark = request.form.get('mark')
        params = {
            "mark": mark,
            "text": request.form.get('short_desc'),
            "user_id": current_user.id,
            "book_id": book_id,
            "status_id": 1
        }
        for param in params:
            param = bleach.clean(param)
        try:
            comment = Comment(**params)
            db.session.add(comment)
            book.rating_sum = book.rating_sum + int(mark) 
            book.rating_num = book.rating_num + 1 
            db.session.commit()
            flash("Рецензия успешно добавлена", "success")
            return redirect(url_for('show', book_id=book_id))
        except:
            db.session.rollback()
            flash('Ошибка при добавлении рецензии', 'danger')
            return redirect(url_for('comments.comment_post', book_id=book_id))
    return render_template('/comments/comment_post.html', book_id=book_id)

@bp.route('/user_comments')
@login_required
def user_comments():
    comments = db.session.execute(db.select(Comment).filter(Comment.user_id == current_user.id)).scalars()
    return render_template('/comments/user_comments.html', comments=comments)

@bp.route('/moder_comments')
@login_required
@check_perm('comments')
def moder_comments():
    page = request.args.get('page', 1, type=int)
    pending_status = db.session.query(ReviewStatus).filter(ReviewStatus.name == 'На рассмотрении').first()
    comments = db.session.query(Comment).filter(Comment.status_id == pending_status.id).order_by(Comment.created_at.desc())    
    pagination = db.paginate(comments, page=page, per_page=PER_PAGE)
    comments = pagination.items
    return render_template('/comments/moder_comments.html', comments=comments, pagination=pagination)

@bp.route('/comment/<int:comment_id>', methods=['GET', 'POST'])
@login_required
@check_perm('comments')
def show_comment(comment_id):
    comment = Comment.query.get_or_404(comment_id)
    if request.method == 'POST':
        if 'approve' in request.form:
            approved_status = db.session.query(ReviewStatus).filter(ReviewStatus.name == 'одобрена').first()
            comment.status_id = approved_status.id
        elif 'reject' in request.form:
            rejected_status = db.session.query(ReviewStatus).filter(ReviewStatus.name == 'отклонена').first()
            comment.status_id = rejected_status.id
        db.session.commit()
        return redirect(url_for('comments.moder_comments'))
    return render_template('/comments/show_comment.html', comment=comment)
