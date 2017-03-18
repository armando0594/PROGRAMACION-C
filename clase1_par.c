/*Dado un arreglo de N números (Donde N tiene que ser menor igual a 1000), buscar el numero Par mas grande, siguiendo las siguientes reglas.
- Debe exponerse cuantas veces es divisible
- El siguiente número a él debe ser impar.
- La suma del número anterior y posterior, deben de dar el numero que se encuentra posicionado.
- El resultado de la division entre 2 del numero par analizado deberá ser igual al número siguiente siguiente en el arreglo.

Inteligencia artificial 16/jueves/2017

*/
#include <stdio.h>   /*declaracion de librerias estandar que utiliza el programa para su funcionalidad */
#include <stdlib.h>  /*libreria para utilizar random*/
#include <time.h>    /*obtenemos el valor del tiempo*/

#define maximo 1000
int arreglo [maximo] ;   
int inicio = 0;
int numeros = 0;
int contador_imp = 0;
int siguiente = 0 , anterior = 0;
int pocision_actual = 0,suma;


 main()
{ 
	
	llenarArreglo();	                    //llamando funciones
	imprimirArreglo();
	Verificar();	
}

llenarArreglo()
{
	srand(time(NULL));             		    // muestra visualmente en segundos el resultado
	while(inicio <= maximo)
	{
		if(inicio%2 == 0)							 // inicializa 
		{
			do
			{
				numeros = rand() % 101;			 // genera numeros aleatorios entre el 0 y 100
			}
			while(numeros %2 == 1);
				arreglo [inicio] = numeros;		 //pocisionamiento 
		}

		if(inicio %2 == 1)
		{
			do
			{
				numeros = rand() % 101;			 //si es par sigue buscando hasta que es par 
			}while(numeros %2 == 0);
			arreglo [inicio] = numeros;	
		}
		inicio++;									 //incremento ciclo
	}
}

imprimirArreglo(void)
{
	while(contador_imp < maximo)
	{
		printf("%d\n",arreglo[contador_imp]);	//impresion de numeros
		contador_imp++;
	}
}

 Verificar(void)
{
	while(contador_imp < maximo)
	{
		if(inicio == 0)
		{
			do
			{
				anterior = arreglo[contador_imp-1];
				siguiente = arreglo[contador_imp+2];
				pocision_actual = arreglo[contador_imp+1];
				suma = anterior + siguiente;
				printf("s%d\n", suma );
			}
			while(suma == pocision_actual);
		contador_imp++;	
		}

	}
} 
