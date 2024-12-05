#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define BUFFER_SIZE 5

int buffer[BUFFER_SIZE];
int count = 0; // Número de elementos en el buffer

sem_t empty;  // Semáforo para controlar espacios vacíos
sem_t full;   // Semáforo para controlar elementos llenos
pthread_mutex_t mutex; // Mutex para proteger el acceso al buffer

void *producer(void *arg) {
    int item;
    for (int i = 0; i < 10; i++) { // Produce 10 elementos
        item = i + 1;
        sem_wait(&empty);  // Espera un espacio vacío
        pthread_mutex_lock(&mutex); // Bloquea el acceso al buffer

        // Agrega el elemento al buffer
        buffer[count++] = item;
        printf("Productor produjo: %d\n", item);

        pthread_mutex_unlock(&mutex); // Libera el acceso al buffer
        sem_post(&full);  // Incrementa el contador de elementos llenos
        sleep(1);  // Simula el tiempo de producción
    }
    return NULL;
}

void *consumer(void *arg) {
    int item;
    for (int i = 0; i < 10; i++) { // Consume 10 elementos
        sem_wait(&full);  // Espera un elemento lleno
        pthread_mutex_lock(&mutex); // Bloquea el acceso al buffer

        // Consume el elemento del buffer
        item = buffer[--count];
        printf("Consumidor consumió: %d\n", item);

        pthread_mutex_unlock(&mutex); // Libera el acceso al buffer
        sem_post(&empty);  // Incrementa el contador de espacios vacíos
        sleep(2);  // Simula el tiempo de consumo
    }
    return NULL;
}

int main() {
    pthread_t prod, cons;

    // Inicializar semáforos y mutex
    sem_init(&empty, 0, BUFFER_SIZE);
    sem_init(&full, 0, 0);
    pthread_mutex_init(&mutex, NULL);

    // Crear hilos productor y consumidor
    pthread_create(&prod, NULL, producer, NULL);
    pthread_create(&cons, NULL, consumer, NULL);

    // Esperar a que los hilos terminen
    pthread_join(prod, NULL);
    pthread_join(cons, NULL);

    // Destruir semáforos y mutex
    sem_destroy(&empty);
    sem_destroy(&full);
    pthread_mutex_destroy(&mutex);

    return 0;
}
