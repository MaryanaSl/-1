# Итоговая работа блока А «Настройки и справочники»

## Описание задачи
Создать конфигурацию «Управление ИТ-фирмой» с базовым набором справочников, поддерживающую управление пользователями ИБ в режиме Предприятия.

# Требования к результату
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

 ++ которая открывается для пользователей с правом доступа «Администрирование»;
 ++ в которой, помимо реквизитов сотрудника, есть флажок «Вход разрешён» и поля ввода «Имя для входа» и «Пароль», отражающие свойства пользователя ИБ.
 ++ При записи сотрудника из этой формы при необходимости должно выполняться:

   +++ создание пользователя ИБ с ролью «БазовыеПрава»;
   +++ изменение его пароля и имени для входа;
   +++ при снятии флажка — отключение стандартной аутентификации.
   +++ Рядом с полем ввода пароля должна быть команда «Случайный пароль», генерирующая случайный пароль и показывающая его пользователю.

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

Процесс выполнения
____________
