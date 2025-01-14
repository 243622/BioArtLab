"""Date to DateTime Migration

Revision ID: 506337426c10
Revises: f1494e591889
Create Date: 2024-10-04 13:10:49.549184

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '506337426c10'
down_revision: Union[str, None] = 'f1494e591889'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
