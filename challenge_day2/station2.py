import datetime

def solution_station_2(input_date):
    japanese_weekdays = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日']
    date_obj = datetime.datetime.strptime(input_date, '%Y-%m-%d')
    weekday_index = (date_obj.weekday() + 1) % 7
    return japanese_weekdays[weekday_index]
