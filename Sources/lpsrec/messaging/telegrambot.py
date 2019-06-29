import telegram
import json
import os

class Bot:

    def __init__(self, chat_id = None, token = None, user_credentials = None):                
        
        if (chat_id is None and token is None and user_credentials is None):            
            raise ValueError ("You need to specify chat_id and token or input the path to a user json credentials having these informations")
        
        elif (chat_id is None and token is not None and user_credentials is None):
            raise ValueError ("You specified a token but chat id is also needed")

        elif (chat_id is None and token is not None  and user_credentials is None):
            raise ValueError ("You specified a chat_id but token is also needed")

        if user_credentials is not None: 
            json_data=open(os.path.expanduser(user_credentials), 'r').read()
            data = json.loads(json_data)

        self.token = token if token else data['token']
        self.chat_id = chat_id if chat_id else data['chat_id']
        self.telegram_bot = telegram.Bot(token=self.token)


    def send_message(self, text = [], imgPath = None, filePath = None):
        if isinstance(text, str):
            text = [text]

        for t in text:
            self.telegram_bot.sendMessage(self.chat_id, text=t)

        if imgPath:
            self.telegram_bot.send_photo(self.chat_id, photo=open(os.path.expanduser(imgPath), 'rb'))

        if filePath:
            self.telegram_bot.send_document(self.chat_id, document=open(os.path.expanduser(filePath), 'rb'))