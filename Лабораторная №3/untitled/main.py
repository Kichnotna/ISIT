import yaml

with open("data.yaml",  encoding="utf-8") as file_stream:
    data = yaml.load(file_stream, Loader=yaml.FullLoader)

objects = data["объекты"]
relations = data["связи"]

print("Выберите объект из списка:")
for i in objects:
    print("\t" + i)

choice_objects = input("Ваш выбор: ")

print("Выберите связь из списка:")
local_relations = []
for i in relations:
    if i["откуда"] == choice_objects:
        if i["связь"] not in local_relations:
            local_relations.append(i["связь"])

for i in local_relations:
    print("\t" + i)

choice_relation = input("Ваш выбор: ")

print("Вывод: ")
for i in relations:
    if i["связь"] == choice_relation and i["откуда"] == choice_objects:
        if choice_relation == "где изображён":
            print("\t" + choice_relation + " " + choice_objects + "?   ->   " + i["куда"])
        elif choice_relation == "что изображено":
            print("\t" + choice_relation + " на объекте " + choice_objects + "?   ->   " + i["куда"])
