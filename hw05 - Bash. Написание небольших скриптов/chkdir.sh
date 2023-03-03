root@ubu2210-main-srv01:~# cat chkdir.sh
#!/bin/bash
#
#Otus курс: Linix.Basic
#Домашняя работа по занятию №5 Bash. Написание простых скриптов
#Выполнил evgeny sergeev

#Функция проверки наличии параметра при запуске скрипта
function sayHi() {
echo '--- Step 1 ---'
echo 'Hi, man!'
echo 'I am a small program that deletes files with the extension: *.bak, *.backup, *.tmp'

if ! [  $arg1 ]; then
      echo 'Please specify the directory in the parameter'
      echo 'Im exiting with code 2'
      exit 2
fi

echo "I see first parameter is", $arg1
}

#Функция проверки соответствия параметра каталогу
function chkDir() {

echo '--- Step 2 ---'
echo 'Im checking your parameter'

if ! [ -d $arg1 ]; then
      echo 'Your parameter is not a directory'
      echo 'Im exiting with code 2'
      exit 2
fi

echo 'Your parameter corresponds to the directory'
}

#Функция проверки наличия в каталоге файлов с нужными расшерениями
#Здесь можно было бы включить возможность подсчета кол-ва файлов с нужными расширениями для вывода в последующем отчета при удалении
function chkFiles() {

echo '--- Step 3 ---'
echo 'Im checking the directory:' $arg1  'for files with extensions: *.bak, *.backup, *.tmp  in your directory'

#Ищем файлы с расширением bak и выводим результат
for myBakFiles in $arg1/*.bak;
 do echo "looking for "bak" files", $myBakFiles

#Если ничего не нашли то фиксируем это в переменной
  if ! [ -f $myBakFiles ]; then
       echo 'Files with extension "bak" not found'
       filesBakAvailability=0
  fi
 done

#Ищем файлы с расширением backup и выводим результат
for myBackupFiles in $arg1/*.backup;
do echo "looking for "backup" files", $myBackupFiles

#Если ничего не нашли то фиксируем это в переменной
  if ! [ -f $myBackupFiles ]; then
       echo 'Files with extension "backup" not found'
       filesBackupAvailability=0
  fi
 done

#Ищем файлы с расширением tmp и выводими результат
for myTmpFiles in $arg1/*.tmp;
do echo "looking for "tmp" files", $myTmpFiles

#Если ничего не нашли то фиксируем это в переменной
  if ! [ -f $myTmpFiles ]; then
       echo 'Files with extension "tmp" not found'
       filesTmpAvailability=0
  fi
 done

}

#Функция удаления файлов с нужными расширениями
function delFiles() {

#По результатам состояний переменных из предыдущий функции chkfiles() выполняем нужные действия и выходим с нужным кодом возврата
echo '--- Step 4 ---'
echo 'We have tmp is '$filesTmpAvailability,' backup is '$filesBackupAvailability,' bak is '$filesBakAvailability

#Удаление будет если хотябы одно из нужных расширений было найдено в заданном каталоге
if   [[ $filesTmpAvailability -eq 0 ]] && [[ $filesBackupAvailability -eq 0 ]] && [[ $filesBakAvailability -eq 0 ]] ; then
      echo 'I have nothing to delete'
      echo 'Im exiting with code 2'
      exit 2
fi

echo 'Starting delete files with the extension: *.bak, *.backup, *.tmp'
echo 'Are you ready?'
read ask
if  [[ $filesTmpAvailability && 1 ]]; then
      find $arg1/ -name *.tmp -delete
fi

if [[ $filesBackupAvailability && 1 ]]; then
      find $arg1/ -name *.backup -delete
fi

if [[ $filesBakAvailability && 1 ]]; then
      find $arg1/ -name *.bak -delete
fi

echo 'All necessary files have been deleted'
echo 'Im exiting with code 0'
exit 0
}


#Задание значения служебным переменным
#Переменные хранят в себе состояние говорящее о наличии файлов с нужными расширениями
filesTmpAvailability=1
#filesTmpCount=0
filesBackupAvailability=1
#filesBackupCount=0
filesBakAvailability=1
#filesBakCount=0

#Принимаем параметр
arg1=$1

#Вызов функций с передачей заданных аргументов
sayHi "$arg1"
chkDir "$arg1"
chkFiles "$arg1"
delFiles "$arg1"

