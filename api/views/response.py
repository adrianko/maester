class Response:

    def __init__(self):
        self.code = 404
        self.msg = ""
        self.data = []

    def setOk(self):
        self.code = 200
        self.code = "Success"

    def setNotFound(self):
        self.code = 404
        self.msg = "Not found"

    def setMoreInfo(self):
        self.code = 400
        self.msg = "More information required"

    def setInvalid(self):
        self.code = 422
        self.msg = "Invalid action"

    def setNotAcceptable(self):
        self.code = 406
        self.msg = "Cannot process request. Bad data."

    def serialize(self):
        return self.__dict__