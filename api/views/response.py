class Response:
    def __init__(self):
        self.code = 404
        self.msg = ""
        self.data = []

    def setOk(self):
        self.code = 200

    def setNotFound(self):
        self.code = 404

    def setMoreInfo(self):
        self.code = 400
        self.msg = "More information required"

    def serialize(self):
        return self.__dict__
