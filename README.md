# OneUnit

Фреймворк для тестирования приложений и библиотек OneScript

## 1. Написание тестов

Следующий пример даёт представление о минимально необходимом наборе компонентов для написания тестов.
В следующих разделах будет представлена дополнительная информация о возможностях фреймворка.

```bsl
#Использовать asserts

&Тест
Процедура МойПервыйТест() Экспорт

    // Дано
    Калькулятор = Новый Калькулятор();

    // Когда
    Результат = Калькулятор.Сложить(1, 1);

    // Тогда
    Ожидаем.Что(Результат).Равно(2);

КонецПроцедуры
```

### 1.1 Аннотации

OneUnit поддерживает следующие аннотации для настройки тестов и расширения возможностей фреймворка.

|Аннотация|Описание|
|---|---|
| `&ТестовыйНабор` | Обозначает, что сценарий является [тестовым набором](#19-жизненный-цикл-экземпляра-тестового-набора), используется для настройки жизненного цикла тестового набора |
| `&Тест` | Обозначает, что метод является простым тестом. Эта аннотация не объявляет никаких параметров, тест исполняется как есть |
| `&ПараметризованныйТест` | Обозначает, что метод является [параметризованным тестом](#111-параметризованные-тесты) |
| `&ПовторяемыйТест` | Обозначает, что метод является [повторяемым тестом](#110-повторяемые-тесты) |
| `&ОтображаемоеИмя` | Объявляет пользовательское [отображаемое имя](#13-отображаемые-имена) для тестового метода |
| `&Порядок` | Используется для настройки [порядка выполнения](#18-порядок-выполнения-тестов) тестовых наборов и методов |
| `&ПередКаждым` | Обозначает, что аннотированный метод должен быть выполнен *перед* **каждым** `&Тест`, `&ПараметризованныйТест` или `&ПовторяемыйТест` методом в текущем наборе |
| `&ПослеКаждого` | Обозначает, что аннотированный метод должен быть выполнен *после* **каждого** `&Тест`, `&ПараметризованныйТест` или `&ПовторяемыйТест` методом в текущем наборе |
| `&ПередВсеми` | Обозначает, что аннотированный метод должен быть выполнен *до* **всех** `&Тест`, `&ПараметризованныйТест` или `&ПовторяемыйТест` методом в текущем наборе  |
| `&ПослеВсех` | Обозначает, что аннотированный метод должен быть выполнен *после* **всех** `&Тест`, `&ПараметризованныйТест` или `&ПовторяемыйТест` методом в текущем наборе  |
| `&Тег` | Используется для объявления [тегов для фильтрации](#17-теги) тестов на уровне набора или метода |
| `&Выключен` | Используется для [отключения](#15-отключение-тестов) тестового набора или тестового метода |
| `&Таймаут` | Используется для провала `&Тест`, `&ПараметризованныйТест` или `&ПовторяемыйТест` метода, если его выполнение превышает заданную продолжительность. |

### 1.2 Тестовые методы и наборы

Тестовые методы и методы жизненного цикла должны быть объявлены локально в тестовом наборе, они не должны возвращать значение (любой результат будет проигнорирован).

> Видимость методов.  
Тестовые методы и методы жизненного цикла должны быть объявлены как `Экспорт`

Следующий тестовый набор демонстрирует использование [`&Тест`](./docs/api/Аннотации/Тест.md) методов и всех поддерживаемых методов жизненного цикла.

```bsl
#Использовать asserts

&ПередВсеми
Процедура ИнициализироватьВсе() Экспорт
КонецПроцедуры

&ПередКаждым
Процедура Инициализировать() Экспорт
КонецПроцедуры

&Тест
Процедура УспешныйТест() Экспорт
КонецПроцедуры

&Тест
Процедура ПадающийТест() Экспорт
    Ожидаем.Что(Ложь, "Падающий тест").ЭтоИстина();
КонецПроцедуры

&Тест
&Выключен("Для демонстрации")
Процедура ПропущенныйТест() Экспорт
    // Не будет выполнен
КонецПроцедуры

&ПослеКаждого
Процедура Завершение() Экспорт
КонецПроцедуры

&ПослеВсех
Процедура ЗавершениеВсех() Экспорт
КонецПроцедуры
```

### 1.3 Отображаемые имена

Тестовые методы могут объявлять пользовательские отображаемые имена через [`&ОтображаемоеИмя`](./docs/api/Аннотации/ОтображаемоеИмя.md) - в котором можно будет использовать пробелы, специальные символы и даже эмодзи, которые будут отображаться в отчётах о тестировании и логе выполнения.

```bsl
&Тест
&ОтображаемоеИмя("Произвольное имя теста содержащее пробелы")
Процедура ТестСОтображаемымИменемСодержащимПробелы() Экспорт
КонецПроцедуры

&Тест
&ОтображаемоеИмя("╯°□°）╯")
Процедура ТестСОтображаемымИменемСодержащимСпециальныеСимволы() Экспорт
КонецПроцедуры

&Тест
&ОтображаемоеИмя("😱")
Процедура ТестСОтображаемымИменемСодержащимЭмодзи() Экспорт
КонецПроцедуры
```

### 1.4 Неперехваченные исключения

В OneUnit если исключение выдаётся из тестового метода или метода жизненного цикла и не перехватывается в этом тестовом методе или методе жизненного цикла, то фреймворк пометит тест как упавший.

В следующем примере `ПадениеПриНеперехваченномИсключении()` методы вызывает исключение `Деление на ноль`. Поскольку исключение не перехватывается, тест будет помечен как упавший.

```bsl
&Тест
Процедура ПадениеПриНеперехваченномИсключении() Экспорт

    // Следующий код выбрасывает исключение деления на ноль, которое вызовет падение теста
    Калькулятор = Новый Калькулятор();
    Калькулятор.Разделить(1, 0);

КонецПроцедуры
```

### 1.5 Отключение тестов

Целые тестовые наборы или отдельные тестовые методы можно *отключить* с помощью аннотации [`&Выключен`](./docs/api/Аннотации/Выключен.md), или с помощью одной из аннотаций перечисленных в разделе [Условное выполнение тестов](#16-условное-выполнение-тестов).  
При применении аннотации `&Выключен` на уровне набора, все методы тестирования и методы жизненного цикла в этом наборе также будут отключены.  
Если тестовый метод отключен через аннотацию [`&Выключен`](./docs/api/Аннотации/Выключен.md), это предотвращает вызовов методов жизненного цикла на уровне метода, таких как [`&ПередКаждым`](./docs/api/Аннотации/ПередКаждым.md), [`&ПослеКаждого`](./docs/api/Аннотации/ПослеКаждого.md). Однако это не предотвращает создание экземпляра тестового набора и не предотвращает выполнение методов жизненного цикла на уровне набора, таких как [`&ПередВсеми`](./docs/api/Аннотации/ПередВсеми.md), [`&ПослеВсех`](./docs/api/Аннотации/ПослеВсех.md).  

Вот [`&Выключен`](./docs/api/Аннотации/Выключен.md) тестовый набор

```bsl
&Тест
Процедура ТестБудетПропущен() Экспорт
КонецПроцедуры

&Выключен("Выключен до устранения ошибки #42")
&ТестовыйНабор
Процедура ПриСозданииОбъекта()
КонецПроцедуры
```

А вот тестовый набор, в котором тестовый метод отключен с помощью аннотации `&Выключен`

```bsl
&Выключен("Выключен до устранения ошибки #42")
&Тест
Процедура ТестБудетПропущен() Экспорт
КонецПроцедуры

&Тест
Процедура ТестБудетВыполнен() Экспорт
КонецПроцедуры
```

### 1.6 Условное выполнение тестов

В дополнение к аннотации [`&Выключен`](./docs/api/Аннотации/Выключен.md), OneUnit также поддерживает несколько других условий, которые позволяют разработчиками включать или отключать тестовые наборы и методы декларативно. Если вы хотите предоставить сведения о том почему тест отключен, каждая аннотация имеет параметр `Причина` в котором вы можете указать причину отключения.

Если зарегистрировано несколько условий, то тест будет отключен, если хотя бы одно из условий истинно. Если тестовый набор отключен все тестовые методы и методы жизненного цикла в этом наборе также будут отключены. Если тестовый метод отключен, то вызовы методов жизненного цикла на уровне метода, таких как [`&ПередКаждым`](./docs/api/Аннотации/ПередКаждым.md), [`&ПослеКаждого`](./docs/api/Аннотации/ПослеКаждого.md), будут пропущены. Однако это не предотвращает создание экземпляра тестового набора и не предотвращает выполнение методов жизненного цикла на уровне набора, таких как [`&ПередВсеми`](./docs/api/Аннотации/ПередВсеми.md), [`&ПослеВсех`](./docs/api/Аннотации/ПослеВсех.md).  

#### 1.6.1 Условия на операционную систему

Набор или тест можно включить или отключить в определённой операционной системе с помощью аннотаций: [`&ВключенНаОС`](./docs/api/Аннотации/ВключенНаОС.md), [`&ВыключенНаОС`](./docs/api/Аннотации/ВыключенНаОС.md).

Операционная система задаётся строкой, которая соответствует одной из следующих констант: `Windows`, `Linux`, `MacOS`

```bsl
&Тест
&ВыключенНаОС("Windows")
Процедура ВыключенНаОСWindows() Экспорт
КонецПроцедуры

&Тест
&ВыключенНаОС("Linux")
Процедура ВыключенНаОСLinux() Экспорт
КонецПроцедуры

&Тест
&ВыключенНаОС("MacOS")
Процедура ВыключенНаОСMacOS() Экспорт
КонецПроцедуры

&Тест
&ВключенНаОС("Windows")
Процедура ВключенНаОСWindows() Экспорт
КонецПроцедуры

&Тест
&ВключенНаОС("Linux")
Процедура ВключенНаОСLinux() Экспорт
КонецПроцедуры

&Тест
&ВключенНаОС("MacOS")
Процедура ВключенНаОСMacOS() Экспорт
КонецПроцедуры
```

#### 1.6.2 Условия на версию OneScript

Набор или тест можно включить или отключить в определённой версии OneScript с помощью аннотаций: [`&ВключенДляOneScript`](./docs/api/Аннотации/ВключенДляOneScript.md), [`&ВыключенДляOneScript`](./docs/api/Аннотации/ВыключенДляOneScript.md).  
Версия OneScript задаётся строкой, которая соответствует шаблону по правилам библиотеки [semver](https://github.com/oscript-library/semver).

```bsl
&Тест
&ВыключенДляOneScript("<2")
Процедура ВыключенДляOneScriptМладшеДвойки() Экспорт
КонецПроцедуры

&Тест
&ВыключенДляOneScript("~2.0")
Процедура ВыключенДляOneScriptСтаршеДвойки() Экспорт
КонецПроцедуры

&Тест
&ВключенДляOneScript("<2")
Процедура ВключенДляOneScriptМладшеДвойки() Экспорт
КонецПроцедуры

&Тест
&ВключенДляOneScript(">2.0")
Процедура ВключенДляOneScriptСтаршеДвойки() Экспорт
КонецПроцедуры
```

#### 1.6.3 Пользовательские условия

Так же вы можете создать свои собственные условия на основе [лямбда выражения](https://github.com/sfaqer/lambdas), для этого используется аннотация [`&ВключенЕсли`](./docs/api/Аннотации/ВключенЕсли.md), [`&ВыключенЕсли`](./docs/api/Аннотации/ВыключенЕсли.md). Лямбда выполняется в контексте тестового набора и может использовать его поля и методы тестового набора. Лямбда выражение должно возвращать булево значение, и не принимать аргументов.

```bsl
&Тест
&ВыключенЕсли("() -> Истина")
Процедура ВыключенВсегда() Экспорт
КонецПроцедуры

&Тест
&ВключенЕсли("() -> Ложь")
Процедура ВключенНикогда() Экспорт
КонецПроцедуры

&Тест
&ВключенЕсли("() -> УсловиеВключения()")
Процедура ТестКоторыйВключенЕслиУсловиеВключенияВернулоИстину() Экспорт
КонецПроцедуры

Функция УсловиеВключения() Экспорт
    Возврат Истина;
КонецФункции
```

### 1.7 Теги

Тестовые наборы и методы могут быть помечены с помощью аннотации [`&Тег`](./docs/api/Аннотации/Тег.md). Эти теги могут быть позже использованы для фильтрации [обнаружения и выполнения тестов](#)

```bsl
&Тест
&Тег("Налоги")
Процедура ТестРасчетНДС()
КонецПроцедуры

&Тег("Быстрый")
&Тег("Модель")
Процедура ПриСозданииОбъекта()
КонецПроцедуры
```

### 1.8 Порядок выполнения тестов

Чтобы настроить порядок выполнения тестов, используйте аннотацию [`&Порядок`](http://autumn-library.github.io/api/autumn/Аннотации/Порядок)  
Разместив её на конструкторе тестового набора, вы будете управлять порядком выполнения набора среди других наборов.  
Разместив её на тестовом методе, вы будете управлять порядком выполнения метода среди других методов набора.

```bsl
&Порядок(2) // Тест будет выполнен вторым
&Тест
Процедура Второй() Экспорт
КонецПроцедуры

&Порядок(1) // Тест будет выполнен первым
&Тест
Процедура Первый() Экспорт
КонецПроцедуры

&Порядок(2) // Порядок выполнения набора
Процедура ПриСозданииОбъекта()
КонецПроцедуры
```

### 1.9 Жизненный цикл экземпляра тестового набора

Чтобы позволить отдельным тестовым методам выполняться изолированно и избежать неожиданных побочных эффектор из-за изменяемого состояния тестового набора, OneUnit создаёт новый экземпляр тестового набора для каждого тестового метода. Этот жизненный цикл тестового набора `Компанейский` является поведением по умолчанию в UneUnit.

> Обратите внимание что экземпляр тестового набора всё равно будет создан если заданный тестовый метод отключен с помощью [условия](#16-условное-выполнение-тестов) (например `&Выключен`, `&ВыключенНаОС`, и т.д) даже если режим жизненного цикла `Компанейский` задан для тестового набора.

Если вы предпочитаете, чтобы OneUnit выполнял все тестовые методы на одном экземпляре тестового набора, аннотируйте конструктор своего тестового набора `&ТестовыйНабор("Одиночка")`. При использовании этого режима новый экземпляр тестового набора будет создан только один раз. Таким образом, если ваши тестовые методы полагаются на состояние, хранящееся в переменных экземпляра тестового набора, вам может может потребоваться сбросить это состояние в методах `&ПередКаждым` или `&ПослеКаждого`

### 1.10 Повторяемые тесты

OneUnit предоставляет возможность повторять тест указанное количество раз, аннотируя тестовый метод с помощью [`&ПовторяемыйТест`](./docs/api/Аннотации/ПовторяемыйТест.md) и указывая количество желаемых повторений. Каждый вызов повторного теста ведёт себя как выполнение обычного `&Тест` метода с полной поддержкой тех же методов жизненного цикла.

В следующем примере показано, как объявить тест с именем `ПовторяемыйТест()` который будет автоматически повторён 10 раз.

```bsl
&ПовторяемыйТест(10)
Процедура ПовторяемыйТест() Экспорт
КонецПроцедуры
```

В дополнение к указанию количества повторений вы можете настроить шаблон пользовательского заполняемого имени для каждого повторения через параметр `Имя` аннотации [`&ПовторяемыйТест`](./docs/api/Аннотации/ПовторяемыйТест.md). Поддерживаются следующие динамически заполняемые элементы шаблона:

* `{ОтображаемоеИмя}`   - По правилам аннотации [`&ОтображаемоеИмя`](./docs/api/Аннотации/ОтображаемоеИмя.md)
* `{ТекущееПовторение}` - Текущее повторение теста
* `{ВсегоПовторений}`   - Всего повторений теста

Отображаемое имя по умолчанию для каждого повторения теста: `"Повторение {ТекущееПовторение} из {ВсегоПовторений}"`. Таким образом, отображаемые имена для отдельных повторений предыдущего примера будут: `Повторение 1 из 10`, `Повторение 2 из 10`, и т.д. Если вы хотите, чтобы [`&ОтображаемоеИмя`](./docs/api/Аннотации/ОтображаемоеИмя.md) метода было включено в имя каждого повторения, вы можете определить свой собственный шаблон.

### 1.11 Параметризованные тесты

Параметризованные тесты позволяют запускать тест несколько раз с разными аргументами. Они объявляются так же, как и обычные `&Тест` методы, но используется аннотация [`&ПараметризованныйТест`](./docs/api/Аннотации/ПараметризованныйТест.md). Кроме того необходимо объявить по крайней мере один [*источник*](#1111-источники-аргументов), который будет предоставлять аргументы для каждого вызова, а затем использовать аргументы в тестовом методе.

В следующем примере демонстрируется параметризованный тест, который использует [`&ИсточникЗначение`](./docs/api/Аннотации/ИсточникЗначение.md) аннотацию для указания константных строк в качестве источника аргументов.

```bsl
&ПараметризованныйТест
&ИсточникЗначение("Потоп")
&ИсточникЗначение("Кабак")
&ИсточникЗначение("Громилы мыли морг")
Процедура Палиндром(Кандидат) Экспорт
    Ожидаем.Что(ЭтоПалиндром(Кандидат)).ЭтоИстина();
КонецПроцедуры
```

При выполнении вышеприведённого примера каждый вызов будет сообщаться отдельно. Например, в консоль будет залогировано следующее:

```console
└─ Палиндром
    ├─ [Потоп] ✔
    ├─ [Кабак] ✔
    └─ [Громилы мыли морг] ✔
```

#### 1.11.1 Источники аргументов

Из коробки OneUnit предоставляет довольно много аннотаций источников аргументов. Каждый из следующих подразделов содержит краткий обзор и пример использования.

##### &ИсточникЗначение

[`ИсточникЗначение`](./docs/api/Аннотации/ИсточникЗначение.md) является одним из самых простых возможных источников аргументов. Он позволяет указать одно или несколько литеральных значений, которые будут использоваться в качестве аргументов для каждого вызова параметризованного тестового метода.

Например, следующий [`&ПараметризованныйТест`](./docs/api/Аннотации/ПараметризованныйТест.md) метод будет вызван три раза со значениями: (1, 2), (3, 4) и (5, 6).

```bsl
&ПараметризованныйТест
&ИсточникЗначение(1, 2)
&ИсточникЗначение(3, 4)
&ИсточникЗначение(5, 6)
Процедура ПараметризованныйТест(Аргумент1, Аргумент2) Экспорт
```

##### &ИсточникНеопределено

Для проверки пограничных случаев и проверки корректного поведения нашего ПО при предоставлении ему некорректных входных данных может быть полезно передать `Неопределено` в качестве значений аргументов наших параметризованных тестов.  
Для этого используется аннотация [`&ИсточникНеопределено`](./docs/api/Аннотации/ИсточникНеопределено.md).

```bsl
&ПараметризованныйТест
&ИсточникНеопределено
Процедура ПараметризованныйТест(ЯНеопределено, ЯТоже) Экспорт
```

##### &ИсточникПеречисление

[`ИсточникПеречисление`](./docs/api/Аннотации/ИсточникПеречисление.md) обеспечивает удобный способ использования констант типа системное перечисление, а так же модулей с полями константами так же известными как пользовательские перечисления.

Системное перечисление:  
При передаче в качестве параметра имени системного перечисления параметризованный тест будет вызван для каждого значения перечисления, которое будет передано в качестве аргумента в первый параметр тестового метода.

```bsl
&ПараметризованныйТест
&ИсточникПеречисление("СтатусСообщения")
Процедура ПараметризованныйТест(Значение) Экспорт
```

Пользовательское перечисление:  
При передаче в качестве параметра имени модуля, параметризованный тест будет вызван для каждого экспортного поля этого модуля, значение которого будет передано в качестве аргумента в первый параметр тестового метода.

```bsl
// МойКласныйМодуль.os

Перем А;
Перем Б;

А = "А";
Б = "Б";

// МойКласныйТест.os

&ПараметризованныйТест
&ИсточникПеречисление("МойКлассныйМодуль")
Процедура ПараметризованныйТест(Значение) Экспорт
// Вызовется дважды: с аргументами: "А" и "Б"
```

##### &ИсточникJSON

[`ИсточникJSON`](./docs/api/Аннотации/ИсточникJSON.md) позволяет использовать JSON строку или файл в качестве источника аргументов для параметризованного теста.  
Переданный json должен представлять из себя массив объектов, в каждом из которых ключ это имя параметра, а значение аргумент.

Аргументы литералом:  
С помощью строкового литерала вы можете передать JSON массив значений параметров, где для каждого JSON объекта будет создать экземпляр тестового метода с соответствующими аргументами.

В данном примере будут вызваны три экземпляра тестового метода с аргументами: (1, 2), (3, 4) и (5, 6).

> Обратите внимание, что порядок полей в рамках JSON объекта не важен, сопоставление идёт по ключу и имени параметра метода

```bsl
&ПараметризованныйТест
&ИсточникJSON(
    "[
    |    {""Параметр1"": 1, ""Параметр2"": 2},
    |    {""Параметр2"": 4, ""Параметр1"": 3},
    |    {""Параметр1"": 5, ""Параметр2"": 6}
    |]"
)
Процедура ПараметризованныйТест(Параметр1, Параметр2);
```

Аргументы файлом:
Вы также можете передать путь к JSON файлу при помощи параметра `Файл` в аннотации. Путь может быть относительным или абсолютным. Относительный путь разрешается относительно текущего каталога, в котором запускается выполнение тестов, обычно это корень проекта.

```bsl
&ПараметризованныйТест
&ИсточникJSON(Файл = "tests/fixtures/params.json")
Процедура ИсточникJSONФайл(Параметр1, Параметр2) Экспорт
```

##### &ИсточникВыражение

[`ИсточникВыражение`](./docs/api/Аннотации/ИсточникВыражение.md) позволяет использовать [лямбда-выражение](https://github.com/sfaqer/lambdas) в качестве источника аргументов для параметризованного теста. Лямбда-выражение не должно иметь параметров и  должно возвращать [процессор коллекции](https://github.com/nixel2007/oscript-fluent?tab=readme-ov-file#класс-процессорколлекций)
из [списоков](https://github.com/sfaqer/collectionos/blob/develop/doc/Списки/Список.md#список) аргументов для параметризованного теста

> Аргументы передаются в тестовый метод в порядке их следования в списке

> Лямбда захватывает объект тестового набора, так что ему доступны публичные\приватные поля объекта а так же экспортные методы

Пример:

```bsl
//  &ПараметризованныйТест
//  &ИсточникВыражение("() -> ПроцессорыКоллекций.ИзНабора(Списки.ИзЭлементов(1, 2), Списки.ИзЭлементов(3, 4))")
//  Процедура Тест(ПараметрПервый, ПараметрВторой)
```

Пример с вызовом локального метода:

```bsl
&ПараметризованныйТест
&ИсточникВыражение("() -> ПоставщикИсточникВыражение()")
Процедура Тест(ПараметрПервый, ПараметрВторой)

Функция ПоставщикИсточникВыражение() Экспорт

    Возврат ПроцессорыКоллекций.ИзНабора(
        Списки.ИзЭлементов(1, 2),
        Списки.ИзЭлементов(3, 4),
        Списки.ИзЭлементов(5, 6)
    );

КонецФункции
```

#### 1.11.2 Настройка отображаемого имени

По умолчанию отображаемое имя параметризованного теста содержит строковое представление всех аргументов конкретного вызова.  
Вы можете настроить отображаемое имя вызова с помощью параметра `Имя` аннотации [`&ПараметризованныйТест`](./docs/api/Аннотации/ПараметризованныйТест.md).

Например:

```bsl
&ПараметризованныйТест(Имя = "Тест с аргументами: {Параметры}")
&ИсточникЗначение(1, 2)
Процедура Тест(Параметры) Экспорт
```

При выполнении вышеприведённого примера каждый вызов будет сообщаться отдельно. Например в консоль будет залогировано следующее:

```console
└─ Тест
    ├─ Тест с аргументами: [1, 2]
    └─ Тест с аргументами: [3, 4]
```

Поддерживаются следующие динамически заполняемые элементы шаблона:

* `{ОтображаемоеИмя}` - По правилам аннотации [`&ОтображаемоеИмя`](./docs/api/Аннотации/ОтображаемоеИмя.md)
* `{Параметры}`       - Строковое представление всех аргументов теста

### 1.12 Таймаут

Аннотация [`&Таймаут`](./docs/api/Аннотации/Таймаут.md) позволяет объявить, что тест должен завершится неудачей, если время его выполнения превышает заданную продолжительность. Единица времени для продолжительности - миллисекунды.

Следующий пример показывает, как `&Таймаут` применяется к тестовому методу.

```bsl
&Тест
&Таймаут(500)
Процедура ТестСТаймаутом() Экспорт
```

Чтобы применить тот же таймаут ко всем тестовым методам в тестовом наборе, можно объявить аннотацию [`&Таймаут`](./docs/api/Аннотации/Таймаут.md) на конструкторе тестового набора.

> Если таймаут указан для [`&ПовторяемыйТест`](./docs/api/Аннотации/ПовторяемыйТест.md) или [`&ПараметризованныйТест`](./docs/api/Аннотации/ПараметризованныйТест.md), то он будет применён к каждому вызову тестового метода.

## 2. Запуск тестов

### 2.1 Запуск тестов из командной строки

OneUnit поставляется вместе с приложением командной строки `oneunit`, которое предоставляет вам возможность выполнять запуск тестов.

Вы можете запустить выполнение тестов по примеру как показано ниже:

```console
$ oneunit execute

├─ СтандартныеТесты (.\tests\СтандартныеТесты.os)
│   ├─ УспешныйТест ✔ (2 мс)
│   └─ ПропущенныйТест ↷ Для демонстрации
└─ СпециальныеТесты (.\tests\СпециальныеТесты.os)
    ├─ Произвольное имя теста содержащее пробелы ✔ (3 мс)
    ├─ ╯°□°）╯ ✔ (1 мс)
    └─ 😱 ✔ (1 мс)

  Запуск тестов завершился за 83 мс

[         2 Наборов обнаружено         ]
[         0 Наборов пропущено          ]
[         2 Наборов успешных           ]
[         0 Наборов ошибочных          ]

[         5 Тестов обнаружено          ]
[         1 Тестов пропущено           ]
[         4 Тестов успешных            ]
[         0 Тестов ошибочных           ]

Тестирование завершилось удачно
```

### 2.1.1 Команды и параметры

Приложение командной строки поддерживает следующие команды:

```console
$ oneunit
Приложение: OneUnit
 Фреймворк тестирования для OneScript

Строка запуска: OneUnit [ОПЦИИ]  КОМАНДА [аргументы...]

Опции:
  -v, --version         показать версию и выйти

Доступные команды:
  help, h       Вывести справку по командам
  discover, d   Выводит в консоль все обнаруженные тесты
  execute, e    Тестирует проект

Для вывода справки по доступным командам наберите: OneUnit КОМАНДА --help
```

#### Обнаружение тестов

```console
$ oneunit discover
Команда: discover, d
 Выводит в консоль все обнаруженные тесты

Строка запуска: OneUnit discover [ОПЦИИ]

Опции:
  -d, --directory               Путь к каталогу с тестовыми наборами, повторяемый.
                                В случае если не были переданы -d и -f принимает значение по умолчанию "./tests"
  -r, --recursive               При поиске тестовых наборов в каталогах искать так же в подкаталогах
  -f, --file                    Путь к файлу с тестами, повторяемый
  -t, --tagsInclude             Теги включаемые в тестовый прогон
  -T, --tagsExclude             Теги исключаемые из тестового прогона
  -s, --testsuiteNameInclude    Тестовые наборы включаемые в тестовый прогон
  -S, --testsuiteNameExclude    Тестовые наборы исключаемые из тестовый прогон
  -m, --testMethodsNameInclude  Тестовые методы включаемые в тестовый прогон
  -M, --testMethodsNameExclude  Тестовые методы исключаемые из тестовый прогон
      --mode                    Режим вывода исполнения в консоль:
                                none    - Не выводить ничего, в случае если были ошибки, то ошибки и статистика будут выведены
                                summary - Выводить только статистику, в случае если были ошибки, то они также будут выведены
                                flat    - Выводить плоский список процесса исполнения теста, а так же ошибки и статистику
                                tree    - Выводить дерево процесса исполнения теста, а так же ошибки и статистику
                                (по умолчанию tree)
```

#### Выполнение тестов

```console
$ oneunit execute
Команда: execute, e
 Тестирует проект

Строка запуска: OneUnit execute [ОПЦИИ]

Опции:
  -d, --directory               Путь к каталогу с тестовыми наборами, повторяемый.
                                В случае если не были переданы -d и -f принимает значение по умолчанию "./tests"
  -r, --recursive               При поиске тестовых наборов в каталогах искать так же в подкаталогах
  -f, --file                    Путь к файлу с тестами, повторяемый
  -t, --tagsInclude             Теги включаемые в тестовый прогон
  -T, --tagsExclude             Теги исключаемые из тестового прогона
  -s, --testsuiteNameInclude    Тестовые наборы включаемые в тестовый прогон
  -S, --testsuiteNameExclude    Тестовые наборы исключаемые из тестовый прогон
  -m, --testMethodsNameInclude  Тестовые методы включаемые в тестовый прогон
  -M, --testMethodsNameExclude  Тестовые методы исключаемые из тестовый прогон
      --timeout                 Время ожидания выполнения каждого теста по умолчанию (в миллисекундах) (по умолчанию 0)
      --junit                   Путь к файлу отчета в формате JUnit
      --genericExecution        Путь к файлу отчета в формате GenericExecution
      --openTestReport          Путь к файлу отчета в формате OpenTestReport
      --genericCoverage         Путь к файлу отчета покрытия в формате GenericCoverage
      --cobertura               Путь к файлу отчета покрытия в формате Cobertura
      --mode                    Режим вывода исполнения в консоль:
                                none    - Не выводить ничего, в случае если были ошибки, то ошибки и статистика будут выведены
                                summary - Выводить только статистику, в случае если были ошибки, то они также будут выведены
                                flat    - Выводить плоский список процесса исполнения теста, а так же ошибки и статистику
                                tree    - Выводить дерево процесса исполнения теста, а так же ошибки и статистику
                                (по умолчанию tree)
```

### 2.1.2 Работа с зависимостями

По умолчанию OneUnit при исполнении будет пытаться уважать зависимости вашего проекта, если вы используете локальные зависимости, то их нужно задать через `oscript.cfg`, который oneunit будет ожидать в текущего каталоге запуска, директориях тестов и в директориях в которых лежат переданные файлы тестов. Вся информация в найденных `oscript.cfg` будет объединена для запуска исполнения oneunit.

> Важно  
При использовании локальных зависимостей проекта, пожалуйста убедитесь что у вас установлены зависимости версий не меньших чем требуется для oneunit, версии нужны для работы указаны в [packagedef](packagedef), если вы используете зависимости версий ниже чем указано, то скорее всего вы получите разнообразные ошибки при запуске тестов.
