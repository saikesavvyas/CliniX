# AI Model of CliniX

This model gives a predictive analysis of what source to prioritize first in the hospital, based on the electrical and environmental data collected in hospitals.

## Step 1) Dataset Creation
This AI Model is trained currently on a synthetic dataset that was created and simulated using MATLAB. The dataset comprises of 9 different columns, namely:
- DailyPatients (Low, Medium, High)
- Criticality (Low, Medium, High)
- WeatherCondition (Sunny, Cloudy, Rainy)
- BatteryLevel (in percentage)
- GridStatus (Available, Unavailable)
- TimeOfDay (Morning, Afternoon, Night)
- Temperature (in Celsius)
- Voltage (in V)
- Current (in A)
The output of the dataset will be in the 10th column which is the "SourceOrder" which is of the format;
- Source1 --> Source2 --> Source3 --> Source4

## Step 2) Training and converting the model 
We have used Tensorflow and Keras in Python to train our AI model. We loaded the dataset first, and then encode some of the columns that has categorical inputs to integers so that it is easy to train the model. Eg: Sunny - 0, Cloudy - 1, Rainy - 2 and vice-versa. Then we save the encoders into a .pkl file using pickle module from python. Similarly, we also preprocess the numeric values and the encoded format of the output column in the files scaler.pkl and y_encoder.pkl respectively. Then we save the model in a .h5 format.
Also, we convert the .h5 file into a quantized .tflite in-order to make it a much more lightweight model and to easily make it compatible with deployment in embedded boards. 
Lastly, we convert the .tflite model into a .h format (C Array) which is understandable by ESP32 rather than a python model.
We also have to convert the encoders and scalers into C arrays so that we deploy them into the ESP32 microcontroller.

## Step 3) ESP32 Deployment
We have used PlatformIO IDE extenstion from Visual Studio Code (VSC) to run inference on our AI Model by running it in the ESP32 board.
We created a project and imported the .h files into the project folder and created a main.cpp file for running the model and to obtain outputs.
