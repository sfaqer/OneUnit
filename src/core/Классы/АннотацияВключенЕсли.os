#Использовать lambdas

Перем _Условие; // Проверяемое лямбда выражение
Перем _Причина; // Причина пропуска теста

// Аннотация определяет что тест выполняется только в случае если переданное выражение вернет `Истина`
//
// Параметры:
//  Значение - Строка - [Лямбда-выражение](https://github.com/oscript-library/lambdas) без параметров, которое
//   должно вернуть `Булево`, `Истина` - тест будет выполнен, `Ложь` - тест будет пропущен, лямбда захватывает
//   объект тестового набора, так что ему доступны публичные\приватные поля объекта а так же экспортные методы
//  Причина  - Строка - Причина почему тест пропущен, которая будет указана в отчете о тестировании
//
// Пример:
//  1.
//  // Включен всегда
//  //
//  &Тест
//  &ВключенЕсли("() -> Истина")
//  Процедура Тест() Экспорт
//   
//  2.
//  // Выключен всегда
//  //
//  &Тест
//  &ВключенЕсли("() -> Ложь", "Я никогда не буду выполнен")
//  Процедура Тест() Экспорт
//   
//  3.
//  // Включен если сегодня среда
//  //
//  &Тест
//  &ВключенЕсли("() -> ДеньНедели(ТекущаяДата()) = 3", "It's not wednesday, my dudes")
//  Процедура Тест() Экспорт
//   
//  4.
//  // МойТестовыйСценарий.os
//  //
//  Перем Поле;
//   
//  // Проверка поля сценария
//  //
//  &Тест
//  &ВключенЕсли("() -> Поле", "В поле сценария была ложь")
//  Процедура Тест() Экспорт
//   
//  5.
//  // МойТестовыйСценарий.os
//  //
//   
//  // Проверка метода сценария
//  //
//  &Тест
//  &ВключенЕсли("() -> ВыполнятьТест()", "Метод ВыполнятьТест вернул ложь")
//  Процедура Тест() Экспорт
//  КонецПроцедуры
//   
//  Функция ВыполнятьТест() Экспорт
//      Возврат Ложь;
//  КонецФункции
//
&Аннотация("ВключенЕсли")
Процедура ПриСозданииОбъекта(Значение, Причина = "Условие переданное во ВключенЕсли вернуло Ложь")
	_Условие = Значение;
	_Причина = Причина;
КонецПроцедуры

Функция Выполнять(Набор) Экспорт

	Результат = Новый Структура("Результат, Причина", Истина, "");

	Включен = Лямбда.Выражение(_Условие)
		.Интерфейс(ФункциональныеИнтерфейсы.Вызываемый())
		.ЗахватитьОбъект(Набор)
		.ВДействие()
		.Выполнить();

	Если Не Включен Тогда
		Результат.Результат = Ложь;
		Результат.Причина = _Причина;
	КонецЕсли;

	Возврат Результат;

КонецФункции
