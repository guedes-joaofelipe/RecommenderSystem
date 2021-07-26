# Installing lib: 
# https://github.com/python-telegram-bot/python-telegram-bot#installing


import sys, os
sys.path.append('../../Utilities') #src directory
from messaging.telegrambot import Bot

# bot = telegram.Bot(token=token)
bot = Bot(user_credentials='./JFGS.json')

bot.send_message(text=["Test message 1", "Test message 2"])
