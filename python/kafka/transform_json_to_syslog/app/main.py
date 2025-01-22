import subprocess
from confluent_kafka import Consumer, KafkaException, KafkaError
from config import settings
from utils.convertsyslog import transform_to_log_format
import json
import logging
import signal
import sys

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuración de Kafka
consumer_config = {
    'bootstrap.servers': settings.KAFKA_BROKER,
    'group.id': settings.KAFKA_GROUP_ID,
    'auto.offset.reset': 'earliest'
}


def consume_kafka_messages():
    consumer = Consumer(consumer_config)

    # Manejar señales para finalizar el consumidor
    def signal_handler(sig, frame):
        logger.info("Finalizando consumidor...")
        consumer.close()
        sys.exit(0)
    signal.signal(signal.SIGINT, signal_handler)

    try:
        consumer.subscribe([settings.KAFKA_TOPIC])
        logger.info("Consumidor suscrito al tópico")

        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    continue
                else:
                    raise KafkaException(msg.error())

            # Transformar mensaje y enviar a Rsyslog
            try:
                message_value = json.loads(msg.value().decode('utf-8'))
                log_message = message_value.get('payload', {})
                parser_log = transform_to_log_format(log_message)
                logger.info(f"Mensaje transformado: {parser_log}")
                # Enviar a Rsyslog
                logger_command = [
                    "logger", "-n", settings.RSYSLOG_SERVER, "-P", str(settings.RSYSLOG_PORT), parser_log
                ]
                subprocess.run(logger_command, check=True)
                logger.info("Mensaje enviado a Rsyslog")
            except json.JSONDecodeError:
                logger.error("Error: Mensaje no es un JSON válido")
            except Exception as e:
                logger.error(f"Error procesando mensaje: {e}")

    finally:
        consumer.close()
        logger.info("Consumidor cerrado")

consume_kafka_messages()
