extends Node

const BIG_BANG: String = "2025-06-07 00:00:00"
const YEAR_OFFSET: int = 2983

const TIME_MULTIPLIER = 10
const SECONDS_PER_MINUTE = 60
const MINUTES_PER_HOUR = 60
const HOURS_PER_DAY = 24
const DAYS_PER_WEEK = 7
const WEEKS_PER_MONTH = 4
const MONTHS_PER_YEAR = 12

func _ready() -> void:
	pass

func convert_to_ingame(getdate: String) -> int:
	var timestamp = Time.get_unix_time_from_datetime_string(getdate)
	return timestamp * TIME_MULTIPLIER

func get_date_object(getdate: String) -> Dictionary:
	# Bin nicht sicher ob das alles so funktioniert wie es soll ;)
	var timestamp = convert_to_ingame(getdate)
	var bb_timestamp = convert_to_ingame(BIG_BANG)
	var tdiff = floor(timestamp - bb_timestamp)
	
	var dMinute = floor(tdiff / SECONDS_PER_MINUTE)
	var dHour = floor(dMinute / MINUTES_PER_HOUR)
	var dDay = floor(dHour / HOURS_PER_DAY)
	var dWeek = floor(dDay / DAYS_PER_WEEK)
	var dMonth = floor(dWeek / WEEKS_PER_MONTH)
	var dYear = floor((dMonth / MONTHS_PER_YEAR) + YEAR_OFFSET)
	
	var tDate = {
		"getdate": timestamp,
		"bigbang": bb_timestamp,
		"minute": dMinute % MINUTES_PER_HOUR,
		"hour": dHour % HOURS_PER_DAY,
		"day": dDay % DAYS_PER_WEEK,
		"week": dWeek,
		"month": dMonth,
		"year": dYear,
	}
	var dateString = "%s-%02d-%02d, Week %d" % [tDate.year, tDate.month, tDate.day, tDate.week]
	var timeString = "%02d:%02d" % [tDate.hour, tDate.minute]
	var dateTimeString = "%s-%02d-%02d %02d:%02d, Week %d" % [tDate.year, tDate.month, tDate.day, tDate.hour, tDate.minute, tDate.week]
	tDate["timestring"] = timeString
	tDate["datestring"] = dateString
	tDate["datetimestring"] = dateTimeString
	return tDate
	
func detect_time_of_day() -> void:
	pass
	
func detect_season() -> void:
	pass
