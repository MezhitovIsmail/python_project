from datetime import datetime
import os
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import UserMixin
from flask import current_app, request, url_for
from check_rights import CheckRights 
from sqlalchemy import MetaData
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey, Text, Integer, MetaData
from typing import Optional

ADMIN_ROLE_ID = 1
MODER_ROLE_ID = 2

convention = {
    "ix": 'ix_%(column_0_label)s',
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}

metadata = MetaData(naming_convention=convention)
db = SQLAlchemy(metadata=metadata)

book_genre = db.Table('book_genre',
                       db.Column('book_id',db.Integer,db.ForeignKey('books.id'),primary_key=True),
                       db.Column('genre_id',db.Integer,db.ForeignKey('genres.id'),primary_key=True))

class Book(db.Model):
    __tablename__ = 'books'
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    short_desc: Mapped[str] = mapped_column(Text, nullable=False)
    year: Mapped[str] = mapped_column(String(4), nullable=False)
    pub_house: Mapped[str] = mapped_column(String(100),nullable=False)
    author: Mapped[str] = mapped_column(String(100), nullable=False)
    volume: Mapped[int] = mapped_column(nullable=False)
    rating_sum: Mapped[int] = mapped_column(default=0)
    rating_num: Mapped[int] = mapped_column(default=0)
    image_id: Mapped[str] = mapped_column(ForeignKey('images.id'))
    genres = relationship('Genre', secondary=book_genre, backref=db.backref('books'), cascade="all,delete")
    image = relationship('Image', cascade="all,delete")

    def __repr__(self):
        return '<Book %r>' % self.name
    
    @property
    def rating(self):
        if self.rating_num > 0:
            return self.rating_sum / self.rating_num
        return 0

class Genre(db.Model):
    __tablename__ = 'genres'
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)

    def __repr__(self):
        return '<Genre %r>' % self.name

class Image(db.Model):
    __tablename__ = 'images'

    id: Mapped[str] = mapped_column(String(100), primary_key=True)
    file_name: Mapped[str] = mapped_column(String(100), nullable=False)
    mime_type: Mapped[str] = mapped_column(String(100), nullable=False)
    md5_hash: Mapped[str] = mapped_column(String(100), nullable=False, unique=True)

    def __repr__(self):
        return '<Image %r>' % self.file_name

    @property
    def storage_filename(self):
        _, ext = os.path.splitext(self.file_name)
        return self.id + ext

    @property
    def url(self):
        return url_for('image', image_id=self.id)

class ReviewStatus(db.Model):
    __tablename__ = 'review_statuses'
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)

    def __repr__(self):
        return '<ReviewStatus %r>' % self.name

class Comment(db.Model):
    __tablename__ = 'comments'
    id: Mapped[int] = mapped_column(primary_key=True)
    mark: Mapped[int] = mapped_column(nullable=False)
    text: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(default=datetime.now)
    book_id: Mapped[int] = mapped_column(ForeignKey('books.id'))
    user_id: Mapped[int] = mapped_column(ForeignKey('users.id'))
    status_id: Mapped[int] = mapped_column(ForeignKey('review_statuses.id'))

    user = relationship('User', cascade="all,delete")
    book = relationship('Book', cascade="all,delete")
    status = relationship('ReviewStatus', cascade='all,delete')

    def get_user(self):
        return db.session.execute(db.select(User).filter_by(id=self.user_id)).scalar().login

    def __repr__(self):
        return '<Comment %r>' % self.text

class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id: Mapped[int] = mapped_column(primary_key=True)
    first_name: Mapped[str] = mapped_column(String(100), nullable=False)
    last_name: Mapped[str] = mapped_column(String(100), nullable=False)
    middle_name: Mapped[Optional[str]] = mapped_column(String(100))
    login: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(256), nullable=False)

    role_id: Mapped[int] = mapped_column(ForeignKey('roles.id'))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def is_admin(self):
        return self.role_id == ADMIN_ROLE_ID
    
    def is_moder(self):
        return self.role_id == MODER_ROLE_ID
    
    def can(self, action, record=None):
        check = CheckRights(record)
        method = getattr(check, action, None)
        if method:
            return method()
        return False

    @property
    def full_name(self):
        return ' '.join([self.last_name, self.first_name, self.middle_name or ''])

    def __repr__(self):
        return '<User %r>' % self.login

class Role(db.Model):
    __tablename__ = 'roles'

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)

    def __repr__(self):
        return '<Role %r>' % self.name
