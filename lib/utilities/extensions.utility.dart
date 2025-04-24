import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ListExtension on List<dynamic>{
  /// Function to multiply a list of any kind
  List<dynamic> multiply(int multiplier){
    List<dynamic> rtn = [];

    for(int i = 0; i < multiplier; i++){
      rtn += this;
    }

    return rtn ;
  }

  /// Function to get a random element out of a List
  dynamic getRandom(){
    Random random = Random();

    return elementAt(
      random.nextInt(length)
    );
  }
}

extension IterableExtension on Iterable{
  /// Function that returns a String o items separated by a comma
  /// 
  /// (ex. Item1, Item2, Item3)
  String toCommaSeparated(){
    String rtn = '';

    for(int i = 0; i < length; i++){
      rtn += elementAt(i).name;
      rtn += (i < length - 1) ? ', ' : '';
    }

    return rtn;
  }
}

extension NumExtension on num{
  /// Function to check if the number is beetween [min] and [max]
  bool isBetween(num min, num max){
    return (this >= min && this <= max);
  }

  /// Function to limit a number, if the number is greater than [max], then [max] is returned; if it's smaller than [min], then [min] is returned
  num limit(num min, num max){
    return this < min ? min : this > max ? max : this;
  }
}

extension StringExtension on String {
  /// Function to write a String in sentence case
  /// 
  /// (ex. 'ciao' --> 'Ciao')
  String toSentenceCase() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// Function to capitalize a String's words
  /// 
  /// (ex. 'ciao come va'--> 'Ciao Come Va')
  String toCapitalizeWord() {
    return split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
}

extension DateTimeExtension on DateTime{
  /// Function to return the locale time
  /// 
  /// (ex. '18:45' / '6:45PM')
  String toLocaleTime(BuildContext context){
    return DateFormat.jm(Localizations.localeOf(context).toString()).format(this);
  }

  /// Function to return the locale day
  /// 
  /// It has (long)day, number, (long)month
  /// 
  /// (ex. 'martedì 1 aprile')
  String toLocaleDayFull(BuildContext context){
    return DateFormat.MMMMEEEEd(Localizations.localeOf(context).toString()).format(this);
  }

  /// Function to return the locale day
  /// 
  /// It has (short)day, number, (long)month
  /// 
  /// (ex. 'mar 1 aprile')
  String toLocaleDayShort(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat('EEE d MMM', locale.toString());
    return formatter.format(this);
  }

  /// Function to return the locale day
  /// 
  /// It has number, (short)month, year
  /// 
  /// (ex. '3 apr 2025')
  String toLocaleDate(BuildContext context){
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(this);
  }

  /// Function to return the (short)month
  /// 
  /// (ex. 'apr')
  String toLocaleMonthShort(BuildContext context){
    return DateFormat.MMM(Localizations.localeOf(context).toString()).format(this);
  }

  /// Function to return the locale day
  /// 
  /// It has number, (short)month
  /// 
  /// (ex. '1 apr')
  String toLocaleDay(BuildContext context){
    return DateFormat("d MMM" ,Localizations.localeOf(context).toString()).format(this);
  }

  /// TODO a function that return a day relative to today
  /// if today ==> 'today' (in the user's language)
  /// if yesterday ==> 'yesterday' (in user's language)
  /// if tomorrow ==> 'tomorrow' (in user's language)
  /// else ==> toLocaleDayShort
  String toRelativeDay(BuildContext context){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = DateTime(year, month, day).difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Oggi';
      case 1:
        return 'Domani';
      case -1:
        return 'Ieri';
      default:
        return toLocaleDay(context);
    }
  }

  /// Function to return a date in the dd/mm/yyyy format
  /// 
  /// Defaults to not show the year, but can be shown
  /// 
  /// (ex. 14/11 - 14/11/2001)
  String toSlashDate({bool showYear = false}) {
    final day = this.day.toString();
    final month = this.month.toString();
    final year = this.year.toString();

    if (showYear) {
      return '$day/$month/$year';
    } else {
      return '$day/$month';
    }
  }
}

extension DurationExtension on Duration{
  /// Function to return the hour in HH:mm(:ss) format
  /// 
  /// Minutes and seconds have a pad left (if necessary)
  /// 
  /// [includeSeconds] is optional, and defaults to false
  /// 
  /// (ex. '1:45' / '1:45:01')
  String toHHmmSS({bool includeSeconds = false}) {
    final Duration absDuration = abs();
    final String sign = isNegative ? '-' : '';

    final int hours = absDuration.inHours;
    final int minutes = absDuration.inMinutes.remainder(60);
    final int seconds = absDuration.inSeconds.remainder(60);

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    final String hoursStr = hours.toString();

    if (includeSeconds) {
      return '$sign$hoursStr:$minutesStr:$secondsStr';
    } else {
      return '$sign$hoursStr:$minutesStr';
    }
  }
}

extension DurationMapSwitch<T> on Map<Duration, T> {
  T switchDuration(Duration duration, {required T Function() defaultCase}) {
    if (containsKey(duration)) {
      return this[duration]!;
    } else {
      return defaultCase();
    }
  }
}

extension BoolExtension on bool{
  bool opposite(){
    return !this;
  }
}

extension BrightnessExtension on Brightness{
  Brightness opposite(){
    return this == Brightness.light ? Brightness.dark : Brightness.light;
  }
}

extension DateFormatExtension on DateFormat {
  /// 📅 Esempio: 13 aprile 2025
  static DateFormat toFullDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMMd(locale);
  }

  /// 🕒 Esempio: 14:30
  static DateFormat toHourMinute(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.Hm(locale);
  }

  /// 🕓 Esempio: 14:30:45
  static DateFormat toHourMinuteSecond(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.Hms(locale);
  }

  /// 📆 Esempio: domenica
  static DateFormat toWeekdayName(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.EEEE(locale);
  }

  /// 📅 Esempio: apr
  static DateFormat toShortMonth(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.MMM(locale);
  }

  /// 🗓️ Esempio: 13 apr 2025
  static DateFormat toShortDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('d MMM y', locale);
  }

  /// 📅 Esempio: 13/04/2025
  static DateFormat toNumericDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMd(locale);
  }

  /// 🕰️ Esempio: 14.30 – 24h oppure 2:30 PM – 12h
  static DateFormat toTimeOfDayFormat(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.jm(locale);
  }

  /// 📅🕒 Esempio: domenica 13 aprile 2025 alle 14:30
  static DateFormat toFullDateTime(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return CapitalizedDateFormat("EEEE d MMMM y, HH:mm", locale);
  }

  /// 🗓️ Esempio: 2025-04-13
  static DateFormat toIsoDate() {
    return DateFormat('yyyy-MM-dd');
  }
  
}

class CapitalizedDateFormat extends DateFormat {
  CapitalizedDateFormat(String super.pattern, [super.locale]);

  @override
  String format(DateTime date) {
    final original = super.format(date);
    return original.toSentenceCase();
  }
}