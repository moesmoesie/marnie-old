import os
def hex_to_rgb(value):
    value = value.lstrip('#')
    lv = len(value)
    return tuple(int(value[i:i+lv//3], 16) for i in range(0, lv, lv//3))

def getSwiftUIColor(rgb):
    return f'UIColor(red: {rgb[0]} / 255.0, green: {rgb[1]} / 255.0, blue: {rgb[2]} / 255.0, alpha: 1)'


textFile = open("colors.txt", "r") 
colors = {}
publisers = []
lightModeNames = []
darkModeNames = []
for line in textFile.readlines():
    lineContent = line.split(" ")
    publisers.append(lineContent[0])
    darkUIName = lineContent[0] + "DarkModeUIColor"
    darkRGB = hex_to_rgb(lineContent[1])

    darkModeNames.append(darkUIName)

    lightUIName = lineContent[0] + "LightModeUIColor"
    lightRGB = hex_to_rgb(lineContent[2].rstrip())
    lightModeNames.append(lightUIName)

    darkUIColor = getSwiftUIColor(darkRGB)
    lightUIColor = getSwiftUIColor(lightRGB)

    colors[darkUIName] = darkUIColor
    colors[lightUIName] = lightUIColor

textFile.close()

text = ""
for name, color in colors.items():
    text +=  "private var " + name + " = " + color + '\n'

text += '\n'

uiPublishersName  = []
publishersName = []
for name in publisers:
    colorName = name + "Color"
    text += f"@Published var {colorName} : Color = .clear \n"
    publishersName.append(colorName)

text+= '\n'

for name in publisers:
    colorName = name + "UIColor"
    text += f"@Published var {colorName} : UIColor = .clear \n"
    uiPublishersName.append(colorName)

text += '\n'

text += "init() { \n"
text += '       self.$darkMode.sink { (darkMode) in\n'

for index in range(len(uiPublishersName)):
    text += f"          self.{publisers[index]}UIColor = darkMode ? self.{darkModeNames[index]} : self.{lightModeNames[index]} \n"
    text += f"          self.{publisers[index]}Color = Color(self.{publisers[index]}UIColor) \n"



text += '       }.store(in: &cancellableSet)\n'
text += '   }}'

theme = "Theme.swift"
lines = []

with open(theme, "r") as f:
    lines = f.readlines()
with open(theme, "w") as f:
    for line in lines:
        f.write(line)
        if "PYTHON GENERATED" in line:
            f.write(text)
            break
