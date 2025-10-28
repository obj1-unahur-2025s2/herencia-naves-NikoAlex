class Nave{
  var velocidadaMaxima = 100000
  var velocidadMinima = 0
  var velocidad
  var direccion
  var combustible

  method prepararViaje() 
  method estaTranquila()
  method avisar()
  method escapar()

  method tienePocaActividad()

  method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()

  method recibirAmenanza() {
    self.escapar()
    self.avisar()
  } 

  method condicionesParaLaTranquilad() {
    return combustible >= 4000 and velocidad <= 12000
  }

  method accionAdicional() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method cargarCombustible(unaCantidad) {
    combustible += unaCantidad
  }

  method descargarCombustible(unaCantidad) {
    combustible = (combustible-unaCantidad).max(0)
  }

  method acelerar(cuanto) {
    velocidad = (velocidad+cuanto).min(velocidadaMaxima)
  }

  method desacelerar(cuanto) {
    velocidad = (velocidad-cuanto).max(velocidadMinima)
  }

  method irHaciaElSol() {
    direccion =10
  }

  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion  =0
  }

  method acercarseUnPocoAlSol() {
    direccion = direccion+1.min(10)
  }

  method alejarseUnPocoAlSol() {
    direccion = direccion-1.max(-10)
  }
}

class NaveBaliza inherits Nave {
  var color
  var cambiaDeColor
  
  method cambiarColorBaliza(nuevoColor) {
    color = nuevoColor
    cambiaDeColor = true
  }

  method color() = color 

  override method prepararViaje() {
    self.accionAdicional()
    self.cambiarColorBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila() = self.condicionesParaLaTranquilad() and (self.color() != "rojo")

  override method tienePocaActividad() = not cambiaDeColor 
}

class NaveDePasajeros inherits Nave {
  var cantidadDePasajeros
  var cantidadDeComida
  var cantidadDeBebida

  method cargarComida(unaCantidad) {
    cantidadDeComida += unaCantidad
  }

  method descargarComida(unaCantidad) {
    cantidadDeComida = (cantidadDeComida - unaCantidad).max(0)
  }

   method cargarBebida(unaCantidad) {
    cantidadDeBebida += unaCantidad
  }

  method descargarBebida(unaCantidad) {
    cantidadDeBebida = (cantidadDeBebida - unaCantidad).max(0)
  }

  method cantidadDeComida() = cantidadDeComida 
  method cantidadDeBebida() = cantidadDeBebida

  override method prepararViaje() {
    self.accionAdicional()
    self.cargarComida(self.cantidadDeComida() + (cantidadDePasajeros*4))
    self.cargarBebida(self.cantidadDeBebida() + (cantidadDeBebida*6))
    self.acercarseUnPocoAlSol()
    
  }

  override method tienePocaActividad () = {} //acumalador


}

class NaveDeCombate inherits Nave {
  var invisible
  var misilesDesplegados
  const mensaje = []

  method ponerseVisible() {
    invisible = false
  }

  method ponerseInvisible() {
    invisible = true
  }

  method estaInvisible() = invisible 

  method desplegarMisiles() {
    misilesDesplegados = true
  }

  method replegarMisiles() {
    misilesDesplegados = false
  }

  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(unMensaje) {
    mensaje.add(unMensaje)
  }

  method mensajesEmitidos() = mensaje

  method primerMensajeEmitido() = mensaje.first()

  method ultimoMensajeEmitido() = mensaje.last()  

  method esEscueta() = mensaje.all({m => m.length()})

  method emitioMensaje(unMensaje) = mensaje.contains(unMensaje) 

  override method prepararViaje() {
    self.accionAdicional()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitioMensaje("Salieron en misión")
  }
  
  override method estaTranquila() = self.condicionesParaLaTranquilad() and not self.misilesDesplegados()

  override method tienePocaActividad() = true 
}

class NaveHospital inherits NaveDePasajeros {
  var quirofranosPreparados

  method prepararQuirofan() {
    quirofranosPreparados = true
  }

  method quirofranosPreparados() = quirofranosPreparados

  method utilizarQuirofranos() {
    quirofranosPreparados = false
  } 

  override method estaTranquila() = self.condicionesParaLaTranquilad() and not self.quirofranosPreparados()
}


class NaveCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = super() and not self.estaInvisible()
}
