class Nave {
  var velocidad 
  var direccion 
  var combustible

  method prepararViaje()
  method escapar()
  method avisar()
  method tienePocaActividad()  

  method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()

  method recibirAmenaza(){
    self.avisar()
    self.escapar()
  }

  method accionAdicional() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila() = combustible <=4000 and velocidad <=12000


  method acelerar(cuanto){velocidad = velocidad+cuanto.min(100000)}
  method desacelerar(cuanto) {velocidad = velocidad-cuanto.max(0)}

  method irHaciaElSol() {direccion=10}
  method escaparDelSol() {direccion=-10}
  method ponerseParaleloAlSol(){ direccion = 0}

  method acercarseUnPocoAlSol() {direccion = direccion+1.min(10)}
  method alejarseUnPocoDelSol(){direccion = direccion-1.max(-10)}

  method cargarCombustible(unaCantidad){combustible += unaCantidad}
  method descargarCombustible(unaCantidad){ combustible = combustible-unaCantidad.max(0)}



}

class NaveBaliza inherits Nave {
  var color
  var cambioDeColor

  method cambiarColorDeBaliza(colorNuevo){
    color = colorNuevo
    cambioDeColor += 1 
    }
  method color() = color

  override method prepararViaje() {
    self.accionAdicional()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method escapar() {
    self.irHaciaElSol()
  }

  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method estaTranquila() = super() and (self.color() != "rojo")

  override method tienePocaActividad() = cambioDeColor==0
}

class NavesDePasajeros inherits Nave {
  var cantidadPasajeros
  var cantidadDeComidas
  var cantidadDeBebidas
  var cantidadDeRacionesDadas

  method cargarComidas(unaCantidad) {cantidadDeComidas += unaCantidad }
  method descargarComidas(unaCantidad) {
    cantidadDeComidas = cantidadDeComidas-unaCantidad.max(0)
    cantidadDeRacionesDadas = unaCantidad
    }
  
  method cargarBebidas(unaCantidad) {cantidadDeBebidas += unaCantidad }
  method descargarBebidas(unaCantidad) {cantidadDeBebidas = cantidadDeBebidas-unaCantidad.max(0)}

  method cantidadDeComidas() = cantidadDeComidas
  method cantidadDeBebidas() = cantidadDeBebidas
  method cantidadPasajeros() = cantidadPasajeros

  override method prepararViaje() {
    self.accionAdicional()
    self.cargarComidas(4*cantidadPasajeros)
    self.cargarBebidas(6*cantidadPasajeros)
    self.acercarseUnPocoAlSol()
  } 

  override method escapar() {
    velocidad = velocidad *2
  }

  override method avisar() {
    self.descargarBebidas(cantidadPasajeros*2)
    self.descargarComidas(cantidadDeComidas)
  }

  override method tienePocaActividad() = cantidadDeRacionesDadas < 50
}

class NaveHospital inherits NavesDePasajeros{
  var estaPreparado 

  method prepararQuirofano() {estaPreparado = true}
  method utilizarQuirofano() {estaPreparado = false}
  method estaPreparado() = estaPreparado 

  override method estaTranquila() = super() and not self.estaPreparado()
  override method recibirAmenaza() {
    super()
    self.prepararQuirofano()
  } 
}

class NaveDeCombate inherits Nave{
  var estaInvisible 
  var misilesDesplegados
  const mensaje = []

  method ponerseVisible() {estaInvisible = false}
  method ponerseInvisible() {estaInvisible = true}
  method estaInvisible() = estaInvisible

  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(unMensaje) {
    mensaje.add(unMensaje)   
  }
  method mensajesEmitidos() {mensaje}
  method primerMensajeEmitido() = mensaje.first()
  method ultimoMensajeEmitido() = mensaje.last()
  method esEscueta() = mensaje.all({m => m.length() < 30})
  method emitioMensaje(unMensaje) = mensaje.concat(unMensaje)

  override method prepararViaje() {
    self.accionAdicional()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = super() and not self.misilesDesplegados()

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar() {
    self.emitirMensaje("AmenazaRecibida")
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = super() and not self.estaInvisible()

  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
