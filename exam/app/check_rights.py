from flask_login import current_user

class CheckRights:
    def __init__(self, record):
        self.record = record

    def comments(self):
        return current_user.is_moder()
    
    def statistic(self):
        return current_user.is_admin()

    def delete(self):
        return current_user.is_admin()

    def create(self):
        return current_user.is_admin()

    def edit(self):
        if current_user.is_admin():
            return True
        if current_user.is_moder():
            return True
            
        return False