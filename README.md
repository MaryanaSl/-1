# Итоговая работа блока А «Настройки и справочники»

## Описание задачи
Создать конфигурацию «Управление ИТ-фирмой» с базовым набором справочников, поддерживающую управление пользователями ИБ в режиме Предприятия.

## Требования к результату
Информационная база должна содержать следующие элементы и особенности:

1. Перечисление «ЮридическоеФизическоеЛицо».
   
2. Справочник «Контрагенты» с определенными реквизитами и формой элемента, удовлетворяющей следующим условиям:

+ КПП должен быть доступен только для контрагентов — юридических лиц. Доступность должна отрабатываться как при изменении типа, так и при перечитывании элемента справочника из ИБ.
+ При изменении наименования "полное наименование" должно заполняться с разворачиванием распространённых сокращений организационно-правовых форм. Например, АО «Вектор» должно превращаться в Акционерное общество «Вектор».
+ Должна быть реализована проверка корректности ИНН как для физических, так и для юридических лиц. Проверять нужно и при попытке записи — с выдачей предупреждения и отказом, и при изменении ИНН — с подсветкой поля ввода или выводом текста ошибки рядом с ним.
+ В форме списка должны присутствовать все существенные реквизиты в разумном порядке.
+ В модуле объекта определено заполнение по умолчанию:
  + Тип — юридическое лицо.
  + Ответственный — текущий сотрудник из параметра сеанса «ТекущийСотрудник.

3. Перечисление «Пол».

4. Справочник «Сотрудники» с реквизитами и модулем менеджера, в котором переопределено получение формы объекта в зависимости от права доступа «Администрирование».

+ С формой элемента «ФормаАдминистратора»:

  + которая открывается для пользователей с правом доступа «Администрирование»;
  + в которой, помимо реквизитов сотрудника, есть флажок «Вход разрешён» и поля ввода «Имя для входа» и «Пароль», отражающие свойства пользователя ИБ.
  + При записи сотрудника из этой формы при необходимости должно выполняться:

   + создание пользователя ИБ с ролью «БазовыеПрава»;
   + изменение его пароля и имени для входа;
   + при снятии флажка — отключение стандартной аутентификации.
   + Рядом с полем ввода пароля должна быть команда «Случайный пароль», генерирующая случайный пароль и показывающая его пользователю.

+ С формой элемента «ФормаПользователя», которая открывается для пользователей без права доступа «Администрирование» и содержит элементы управления для реквизитов сотрудника, упорядоченные по смыслу.

5. Константа и функциональная опция «ВестиРасчётЗарплаты».
 + Константа не должна присутствовать в командном интерфейсе сама по себе — флажок «Использовать стандартные команды» должен быть снят.
 + В состав ФО должны входить реквизиты, относящиеся к расчету зарплаты, справочника «Сотрудники», а константа должна присутствовать флажком в общей форме «НастройкаПрограммы».

6. Общая форма и общая команда «НастройкаПрограммы».
 + Форма должна содержать основной реквизит типа «НаборКонстант» и поле флажка для константы «ВестиРасчётЗарплаты».
 + Общая команда должна открывать общую форму, принадлежать подсистеме «Настройки» и присутствовать в командном интерфейсе раздела «Настройки».

7. Параметр сеанса «ТекущийСотрудник» - Тип «СправочникСсылка.Сотрудники». Должен заполняться элементом справочника «Сотрудники», идентификатор пользователя ИБ которого совпадает с идентификатором текущего пользователя ИБ.

8. Роли «БазовыеПрава» и «ПолныеПрава». Роль «ПолныеПрава» должна давать права на всё, кроме интерактивного удаления элементов справочников.
Роль «БазовыеПрава» должна давать права на чтение, просмотр и ввод по строке всех данных. Редактирование, добавление и изменение разрешается только для справочника «Контрагенты». Роль не должна давать права на открытие настроек программы.

9. Подсистема «Настройки»».
Содержащая все справочники и общую команду «НастройкаПрограммы».

## Процесс выполнения

Весь проект можно найти в репозитории, ниже покажу на мой взгляд, интересные для меня задачи:

1. В форме элемента справочника Контрагенты реализовать следующее:
   + При изменении наименования "полное наименование" должно заполняться с разворачиванием распространённых сокращений организационно-правовых форм. Например, АО «Вектор» должно превращаться в Акционерное общество «Вектор».

Для решения данной задачив форме создала доп. реквизит с типом Булево "ПолноеНаименованиеМенялосьВручную".
![image](https://github.com/user-attachments/assets/1f750050-1c5d-4a06-9eef-b21a9a1bb427)
Ниже приведу часть кода из модуля формы элемента:
``` 1С
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект) //при открытии карточки контрагента
	
	//реализуем управление видимостью поля КПП в зависимости от типа контрагента
	//физ лицо - кпп - скрыть
	
	УстановитьВидимостьКПП(Объект.ЮридическоеФизическоеЛицо, ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"), Элементы.КПП.Видимость);
	
	//при чтении формы получить полное наименование из краткого
	//и сверить его с полным наименование на форме 
	//если результат при чтении формы не равен тому, что уже есть на форме,
	//то в невидимом булевском реквизите формы "Полное наименование менялось вручную"
	//указать истину, т.е. это поле менялось вручную 
	
	ПроверкаПолногоНаименования =  СформироватьПолноеНаименование(Объект.Наименование);
	
	Если Врег(ПроверкаПолногоНаименования) = Врег(Объект.ПолноеНаименование) Тогда
		ПолноеНаименованиеМенялосьВручную = Ложь;
	Иначе
		ПолноеНаименованиеМенялосьВручную = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент) 
	
	//реализовать поиск распространённых сокращений организационно-правовых форм в начале строки
	//и заполнение полного наименования по краткому с заменой сокращения ОПФ на её полное наименование
	
	//Не изменять полное наименование, если оно уже было изменено пользователем вручную
	//Чтобы это реализовать, при чтении формы получайте полное наименование из краткого
	
	Если ПолноеНаименованиеМенялосьВручную = Ложь Тогда
		Объект.ПолноеНаименование = СформироватьПолноеНаименование(Объект.Наименование); 
	ИначеЕсли ПолноеНаименованиеМенялосьВручную = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПолноеНаименование(КраткоеНаименование)
	
	//реализовать поиск распространённых сокращений организационно-правовых форм в начале строки
	//и заполнение полного наименования по краткому с заменой сокращения ОПФ на её полное наименование
	
	//создадим соответствия. Где Ключ - сокращение ОПФ. Значение - полное название ОПФ
	АббревиатурыОрганизационноПравовыхФорм = Новый Соответствие;
	АббревиатурыОрганизационноПравовыхФорм.Вставить("ООО", "Общество с Ограниченной Ответственностью");
	АббревиатурыОрганизационноПравовыхФорм.Вставить("ОАО", "Открытое Акционерное Общество");
	АббревиатурыОрганизационноПравовыхФорм.Вставить("ПАО", "Публичное Акционерное Общество");
	АббревиатурыОрганизационноПравовыхФорм.Вставить("НАО", "Непубличное Акцианерное Общество");
	АббревиатурыОрганизационноПравовыхФорм.Вставить("ИП", "Индивидуальный Предприниматель");
	АббревиатурыОрганизационноПравовыхФорм.Вставить("ЗАО", "Закрытое Акционерное Общество"); 
	АббревиатурыОрганизационноПравовыхФорм.Вставить("АО", "Акционерное Общество");
	
	//получим массив слов из Краткого наименования
	МассивСловКраткогоНаименования = СтрРазделить(КраткоеНаименование, " "); 
	
	//пройдемся в цикле по всем словам массива 
	Для К=0 по МассивСловКраткогоНаименования.ВГраница() Цикл
		
		//примем, что слово из массива - ключ дл соотвествия
		КлючДляСоотвествия = Врег(МассивСловКраткогоНаименования[К]);
		
		//получим значение из соотвествия по ключу
		ЗначениеИзСоотвествия = АббревиатурыОрганизационноПравовыхФорм[КлючДляСоотвествия];
		
		Если Не ЗначениеИзСоотвествия = Неопределено Тогда 
			//слово из краткого наименования = значени из соотвествия (полная расшифрова ОПФ)
			МассивСловКраткогоНаименования[К] = ЗначениеИзСоотвествия;
			
			Прервать; //нет смысла дальше искать ОПФ
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПолноеНаименование = СтрСоединить(МассивСловКраткогоНаименования, " ");
	
	Возврат  ПолноеНаименование;
	
КонецФункции



```

