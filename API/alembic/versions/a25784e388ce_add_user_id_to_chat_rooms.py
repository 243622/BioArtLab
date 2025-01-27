"""Add user_id to chat_rooms

Revision ID: a25784e388ce
Revises: 28a7c49f31ac
Create Date: 2025-01-23 09:50:01.752259

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = 'a25784e388ce'
down_revision: Union[str, None] = '28a7c49f31ac'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add user_id column to chat_rooms table
    op.add_column('chat_rooms', sa.Column('user_id', sa.Integer(), nullable=True))
    op.create_foreign_key(None, 'chat_rooms', 'users', ['user_id'], ['userId'])


def downgrade() -> None:
    # Remove user_id column from chat_rooms table
    op.drop_constraint(None, 'chat_rooms', type_='foreignkey')
    op.drop_column('chat_rooms', 'user_id')