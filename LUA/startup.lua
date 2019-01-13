print("startup")

mqtt_broker="152.77.47.50"
mqtt_port=6883
mqtt_user= nil
mqtt_password=nil
deviceID="etud21"

topic = ""
msg   = ""

pin_input=0

function mqtt_connect()
    print("Trying to connect to MQTT broker "..mqtt_broker)
    m = mqtt.Client(deviceID, 120, mqtt_user, mqtt_password, 1)
    m:on("message", on_message)
    m:connect(mqtt_broker, mqtt_port, 0, 0, on_connect)
end

function on_connect(client)
    m:subscribe(deviceID.."/ctrl/#", 0)
    print("successfully connected to MQTT broker "..mqtt_broker)

    mytimer = tmr.create()
    mytimer:register(60000, tmr.ALARM_AUTO, send_humidity_level)
    mytimer:start()
end

function on_message(client,topic,msg)
    print("receive message from "..topic)
    print("message : "..msg)
end

function publish (topic, msg)
    print("publishing to topic : "..topic)
    print("message : "..msg)
    m:publish(topic, msg, 0, 1)
end

function send_memory_state ()
    heat = node.heap()
    publish(deviceID.."/heap", heat)
end

function send_humidity_level ()
    humidity = adc.read(pin_input)
    publish(deviceID.."/data/WeMos/humidite/humidity", "{\"humidity\":"..humidity.."}")
end

mqtt_connect()
