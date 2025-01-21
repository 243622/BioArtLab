import unittest
from unittest.mock import patch, MagicMock
from index import send_email, check_food_quantity, SessionLocal, models

class TestEmailFunctions(unittest.TestCase):

    def test_send_email(self):
        send_email("Test Subject", "Test Body", "marius.gump@gmail.com")

    @patch('index.SessionLocal')
    def test_check_food_quantity(self, mock_session):
        mock_db = MagicMock()
        mock_session.return_value = mock_db

        stock_item = models.Stock(quantity=5, minimumQuantity=10, foodTypeId=1)
        mock_db.query.return_value.all.return_value = [stock_item]

        check_food_quantity()

if __name__ == '__main__':
    unittest.main()