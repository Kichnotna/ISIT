import imageio
import numpy as np
from keras.models import load_model

model = load_model('fit_neural_network.h5')


def predict(filename):
    image = imageio.v3.imread(filename)
    image = np.mean(image, 2, dtype=float)
    image = image / 255

    image = np.expand_dims(image, 0)
    image = np.expand_dims(image, -1)

    res = model.predict([image])[0]
    return np.argmax(res), max(res)


print("Модель загружена")
