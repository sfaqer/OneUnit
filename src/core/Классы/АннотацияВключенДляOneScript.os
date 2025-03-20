#Использовать semver
#Использовать annotations

Перем _Причина; // Причина пропуска
Перем _Версия;  // Проверяемая версия OneScript

// Аннотация определяет что тест выполняется только для версий OneScript соответствующих указанному диапазону.
// Диапазон задаётся по правилам библиотеки [semver](https://github.com/oscript-library/semver)
//
// Параметры:
//  Значение - Строка - Диапазон проверяемой версии
//  Причина  - Строка - Причина почему тест пропущен, которая будет указана в отчете о тестировании
//
// Пример:
//  1.
//  // Включен для OneScript версий младше 2
//  //
//  &Тест
//  &ВключенДляOneScript("<2")
//  Процедура Тест() Экспорт
//   
//  2.
//  // Включен для OneScript версий старше или равном 2
//  //
//  &Тест
//  &ВключенДляOneScript("~2", "Используются фичи версии 2")
//  Процедура Тест() Экспорт
//
&Аннотация("ВключенДляOneScript")
&ВключенЕсли(Значение = "")
Процедура ПриСозданииОбъекта(Значение, Причина = "Выключен для текущей версии OneScript")
	_Версия  = Значение;
	_Причина = Причина;
КонецПроцедуры

Процедура ПриРазворачиванииАннотации(ОпределениеАннотации, ПодчиненныеАннотации, ВладелецСвойства, Свойство) Экспорт

	Аннотация = РаботаСАннотациями.НайтиАннотацию(ПодчиненныеАннотации, "ВключенЕсли");

	РаботаСАннотациями.УстановитьЗначениеПараметраАннотации(
		Аннотация,
		"Значение",
		СтрШаблон("() -> Версии.ВерсияВДиапазоне(Новый СистемнаяИнформация().Версия, ""%1"");", _Версия)
	);

	РаботаСАннотациями.УстановитьЗначениеПараметраАннотации(Аннотация, "Причина", _Причина);

КонецПроцедуры
