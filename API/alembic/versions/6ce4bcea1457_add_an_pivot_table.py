"""Create user_chat_rooms table

Revision ID: b12345c67890
Revises: a25784e388ce
Create Date: 2025-01-23 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'b12345c67890'
down_revision = 'a25784e388ce'
branch_labels = None
depends_on = None

def upgrade() -> None:
    op.create_table(
        'user_chat_rooms',
        sa.Column('id', sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.userId')),
        sa.Column('chat_room_id', sa.Integer(), sa.ForeignKey('chat_rooms.id'))
    )

def downgrade() -> None:
    op.drop_table('user_chat_rooms')