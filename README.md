# Caso-1-Payment-Assistant-Bases-1

## Estudiantes :  
  Rachell Leiva Abarca 2024220640
  Daniel Stiben Sequeira Requenes 2023282470

## Solo calificar entregable 1


Esta base de datos es destinada para un payment assistant que por medio de guías de voz y notificaciones realiza pagos de servicios de manera automática cada cierto tiempo establecido, pero antes de realizar el pago debe haber una confirmación.


Entre las tablas relacionadas a las entidades, posee una tabla de servicios suscritos que se conecta a la tabla de users en una relación 1 user a n servicios suscritos, ya que un user puede tener más de un servicio que desea pagar, esta tabla posee las entidades de nombre de servicio del usuario, que permite que la persona lo personalice si desea un nombre especial para identificarlo mejor, otra es el contrato del serivicio que puede ser un número pero como en ocasiones lleva guiones o inclusive letras se pone en varchar apara evitar errores, además, posee un enabled que empieza con un valor 1 al suscribirse al servicio, pero si después desea desactivarlo se cambiaría el valor a 0 indicándolo. 


Esta tabla está conectada a la de servicios disponibles, ya que puede existir diversos servicios, pero no todos los pago o utiliza el user, por tanto la columna presente en este es el nombre del servicio que podría ser pago del AyA, por ejemplo.


Esta tabla de servicios disponibles se conecta a otras dos, una de tipos de servicios que sirve para organizar en categorías los servicios y así sea más sencillo ordenarlos, por tanto la relación es de 1 tipo n servicios disponibles, además, contiene únicamente su id y el nombre del tipo. La otra tabla a la que se conecta es la de la compañía, que tiene únicamente el nombre de la compañía y se relaciona 1 compañía puede tener n servicios disponibles.


Otro grupo de tablas está destinado a las notificaciones, la primera tabla de notificaciones   esta contiene su id, una fecha para la notificación, el contrato del servicio que debe pagar, un monto actual de lo que debe pagar en decimal para que trabaje bien con montos grandes y con decimales, además una confirmación que debe estar en , otra columna es el mensaje que indica la notificación, también el medio por el que se contacta a la empresa, otra contiene el destino de la notificación de igual manera escrito y una con el estado de la notificación.

Esta tabla de notificaciones esta relacionada con user mediante 1 users n notificaciones, también está conectada a los pagos mediante 1 pago n notificaciones ya que puede enviarse más de una notificación. Se conecta además a la de los contactos del user para poder enviar mediante estos las notificaciones.


Además, la tabla de notificaciones se conecta a la de medio de notificación mediante la relación 1 notificación puede tener n medios, esta tabla solo contiene el nombre del medio que puede ser mensaje o notificación push, por ejemplo. 


Por otra parte existe la tabla de recibo de transacción que se conecta a la de transacciones mediante la relación 1 transacción n recibos, esta contiene el id, el url al pdf con el recibo y un deleted que indique si lo eliminaron o no medinate un bit.Esta tabla de recibo se conecta a la de media type de los recibos que contiene el id, el nombre del media type y el player implemente para saber con que ejecutar el archivo del recibo. 
