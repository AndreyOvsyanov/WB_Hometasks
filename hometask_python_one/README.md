# WB_Python_task_one

После выполнения домашнюю работу необходимо опубликовать в git Дедлайн до 11.10.2023 23:59 
1. Установить Python 3 (от 3.9)
2. Настроить окружение в Poetry 
3. Установить pandas,  numpy и 	jupyterlab в окружении
4. Запустить jupyter notebook и написать скрипт на питон выводящий версии установленных библиотек 

# Решение

1. Установить Python 3 (от 3.9)\
   Установил Python 3.12

3. Настроить окружение в Poetry\
   Установим poetry командой\
   ``` pip instal poetry ```

   Следующей командой создадим проект в poetry, у нас появится pyproject.toml\
   ``` poetry new my_project ```

   Переключимся на него командой\
   ``` cd my_project ```

4. Установить pandas,  numpy и 	jupyterlab в окружении\
   Установим нужные библиотеки командой\
   ``` poetry add numpy pandas jupyterlab ```

   Файл pyproject.toml\
```
[tool.poetry]
name = "my-project"
version = "0.1.0"
description = ""
authors = ["AndreyOvsyanov <andrey01109@gmail.com>"]
readme = "README.md"
packages = [{include = "my_project"}]

[tool.poetry.dependencies]
python = "^3.9"
numpy = "^1.26.0"
pandas = "^2.1.1"
jupyterlab = "^4.0.6"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

4. Запускаем jupyterlab в окружении Poetry\
``` poetry run jupyter lab ```

![image](https://github.com/AndreyOvsyanov/WB_Python_task_one/assets/61729661/e398b109-bf2c-4308-8eaa-3f20340ec212)
![image](https://github.com/AndreyOvsyanov/WB_Python_task_one/assets/61729661/b5dd7727-8c8b-4a33-8766-dc416e280935)

jupyter lab
![image](https://github.com/AndreyOvsyanov/WB_Python_task_one/assets/61729661/346ae053-6c85-4915-a9ba-e9b874499125)

Cкрипт, выводящий версии установленных библиотек
![image](https://github.com/AndreyOvsyanov/WB_Python_task_one/assets/61729661/8e72a818-f6ff-4a4a-93f7-c6aea859ddf2)
