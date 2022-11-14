import json


def And(*params):
    return all(params)


def AskValue(question):
    while True:
        answer = input(question)
        if answer.isdigit():
            break
    return answer


def Biggest(param, value):
    if not (param in variables):
        variables[param] = 0
    return float(variables[param]) > float(value)


def Compare(param, value):
    if not (param in variables):
        variables[param] = 0
    return variables[param] == value


def Or(*params):
    return any(params)


def Print(text):
    print(text)


def SetValue(param, value):
    variables[param] = value
    return variables[param]


def YesOrNo(question):
    answer = ""

    while answer != "yes" and answer != "no":
        answer = input(question)

        if answer == "y":
            answer = "yes"
        if answer == "n":
            answer = "no"
    return answer


methods = {"and": And, "askValue": AskValue, "biggest": Biggest, "compare": Compare, "or": Or, "print": Print, "setValue": SetValue, "yesOrNo": YesOrNo}
variables = {"solution": 0}


with open("rules.json", "r", encoding="utf-8") as rules:
    data = json.load(rules)


def ruleManager(part):
    total_arguments = []
    if isinstance(part["arguments"], str):
        total_arguments.append(part["arguments"])
    else:
        for arg in part["arguments"]:
            if not (isinstance(arg, dict)):
                total_arguments.append(arg)
            else:
                total_arguments.append(ruleManager(arg))
    return methods.get(part["method"])(*total_arguments)


def ruleHandler():
    i = len(data) - 1
    skip = []
    while variables["solution"] == 0 and i > 0:
        if i not in skip:
            if ruleManager(data[i]["condition"]):
                ruleManager(data[i]["result"])
                skip.append(i)
                i = len(data)
        i -= 1


ruleHandler()
