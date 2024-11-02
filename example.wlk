const objetosRasos = ["banana.png"]
const objetosConAltura = ["pera.png","moneda.png"]

object juegoDeDinosaurio {
  
  method iniciar() {
    const objetos = objetosRasos + objetosConAltura + [null]
    // pueden aparecer un objeto que vaya por el suelo (objetosRasos), 
    // uno que vaya por el aire (objetosConAltura) o ninguno (null)
    game.width(45)
    game.height(20)
    game.addVisual(dinosaurio)
    game.onTick(
      1000,
      "aparecerObjeto",
      { self.aparecer(objetos.anyOne()) }
    )
    
    keyboard.space().onPressDo({ dinosaurio.salta() })
    
    game.whenCollideDo(dinosaurio, { elemento => elemento.teChocoElDino(elemento.image()) })
  }
  
  method aparecer(objeto) {
    if( objeto != null ) {
      if (objetosRasos.contains(objeto)) self.crearObjetoRaso(objeto)
      else self.crearObjetoConAltura(objeto)
    }
  }
  
  method crearObjetoRaso(objeto) {
    const objetoCreado = new ObjetoRaso(image = objeto)
    self.apareceYMovete(objetoCreado)
  }
  
  method crearObjetoConAltura(objeto) {
    const objetoCreado = new ObjetoConAltura(image = objeto)
    self.apareceYMovete(objetoCreado)
  }
  
  method apareceYMovete(objeto) {
    game.addVisual(objeto)
    game.onTick(100, "desplazamiento", { objeto.desplazate(2) })
  }
}

object dinosaurio {
  var property position = game.origin()
  var property image = "manzana.png"
  
  method salta() {
    if (position == game.origin()) {
      self.subir()
      game.schedule(450, { self.bajar() })
    }
  }
  
  method bajar() {
    position = game.origin()
  }
  
  method subir() {
    position = position.up(4)
  }

  method sumarPtos(){}
  method otraCosa(){}
}

class ObjetoRaso {
  var property position = game.at(game.width() - 1, self.posY())
  var property image
  
  method posY() = 0
  
  method teChocoElDino(_) {
    game.stop()
  }
  // si el dino choca con un objeto que va x el suelo el juego termina
  
  method desplazate(n) {
    position = position.left(n)
  }
}

class ObjetoConAltura inherits ObjetoRaso {
  override method posY() = 4
  // cambiar 4 por valor al azar

  override method teChocoElDino(objetoChocado) {
    if(objetoChocado=="moneda.png") dinosaurio.sumarPtos()
    if(objetoChocado=="pera.png") dinosaurio.otraCosa()
  }
  // si el dino choca con un objeto que va x el aire pueden pasar varias cosas
}
