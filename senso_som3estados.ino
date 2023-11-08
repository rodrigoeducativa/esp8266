
const int janelaAmostragem = 150; // Largura da janela de amostragem em mS (50 mS = 20Hz)
unsigned int amostra;

#define PINO_SENSOR 17 //A0
#define PINO_CALMO 14 //D5
#define PINO_MODERADO 2 //D4
#define PINO_ALTO 13 //D7

void setup()
{
    pinMode(PINO_SENSOR, INPUT); // Configura o pino do sensor como entrada
    pinMode(PINO_CALMO, OUTPUT);
    pinMode(PINO_MODERADO, OUTPUT);
    pinMode(PINO_ALTO, OUTPUT);

    digitalWrite(PINO_CALMO, LOW);
    digitalWrite(PINO_MODERADO, LOW);
    digitalWrite(PINO_ALTO, LOW);

    Serial.begin(115200);
  
}

void loop()
{
  
    unsigned long inicioMillis = millis(); // Início da janela de amostragem
    float picoAPico = 0; // Nível pico a pico

    unsigned int sinalMaximo = 0; // Valor mínimo
    unsigned int sinalMinimo = 1024; // Valor máximo

    // Coleta dados por 50 mS
    while (millis() - inicioMillis < janelaAmostragem)
    {
        amostra = analogRead(PINO_SENSOR); // Obtém leitura do microfone
        if (amostra < 1024) // Descarta leituras espúrias
        {
            if (amostra > sinalMaximo)
            {
                sinalMaximo = amostra; // Salva apenas os níveis máximos
            }
            else if (amostra < sinalMinimo)
            {
                sinalMinimo = amostra; // Salva apenas os níveis mínimos
            }
        }
    }

    picoAPico = sinalMaximo - sinalMinimo; // Máximo - mínimo = amplitude pico a pico
    int decibeis = map(picoAPico, 20, 800, 30, 150) * 1.75; // Calibrar para decibéis conforme app celular
    

    if (decibeis <= 62)
    {
       
        digitalWrite(PINO_CALMO, HIGH);
        digitalWrite(PINO_MODERADO, LOW);
        digitalWrite(PINO_ALTO, LOW);
        
        Serial.println(decibeis);
        
        
    } else if (decibeis > 62 && decibeis < 105)   {
       
         lightRGB(PINO_ALTO, PINO_CALMO, PINO_MODERADO);
        
        Serial.println(decibeis);
        
        
    }
    else if (decibeis >= 105)
    {
      
        digitalWrite(PINO_CALMO, LOW);
        digitalWrite(PINO_MODERADO, LOW);
        digitalWrite(PINO_ALTO, HIGH);
        
        Serial.println(decibeis);
        
    }

    delay(300);
   
}

//Função para cor amarela do led rgb
void lightRGB(int r, int g, int b){
  analogWrite(PINO_ALTO, 255);
  analogWrite(PINO_CALMO,255);
  analogWrite(PINO_MODERADO, 0);
  
  }