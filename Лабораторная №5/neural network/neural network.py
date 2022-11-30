import keras
from keras.datasets import mnist
from tensorflow.python.ops import nn

(x_train, y_train), (x_test, y_test) = mnist.load_data()

num_classes = 10
x_train = x_train.reshape(x_train.shape[0], 28, 28, 1)
x_test = x_test.reshape(x_test.shape[0], 28, 28, 1)

y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

epochs = 5

model = keras.models.Sequential([
    keras.layers.Conv2D(
        input_shape=(28, 28, 1),
        filters=32,
        kernel_size=(5, 5),
        padding='same',
        activation='relu'
    ),
    keras.layers.MaxPool2D(pool_size=(2, 2)),
    keras.layers.Conv2D(
        filters=64,
        kernel_size=(5, 5),
        padding='same',
        activation='relu'
    ),
    keras.layers.MaxPool2D(pool_size=(2, 2)),
    keras.layers.Flatten(),
    keras.layers.Dense(1024, activation=nn.relu),
    keras.layers.Dropout(0.2),
    keras.layers.Dense(10, activation=nn.softmax)
])

model.compile(
    optimizer=keras.optimizers.Adadelta(),
    loss=keras.losses.categorical_crossentropy,
    metrics=['accuracy']
)

model.fit(
    x_train,
    y_train,
    epochs=epochs,
    validation_data=(x_test, y_test))

model.save('fit_neural_network.h5')
print("Модель сохранена")
