import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/src/models/actividad_model.dart';
import 'package:to_do_list/src/provider/list_provider.dart'; 
import 'package:to_do_list/src/styles/styles.dart' as style;

class ListaActividades extends StatelessWidget { 

  final List<ActividadModel> actividades; 
  const ListaActividades(this.actividades);

  @override
  Widget build(BuildContext context) { 
    

    return ListView.builder(
      itemCount: actividades.length,
      itemBuilder: (BuildContext context, int index){

          return _Actividad(actividad: actividades[index]);

      }
    );
  }
}

class _Actividad extends StatelessWidget {

  final ActividadModel actividad; 

  const _Actividad({ required this.actividad}); 
  
  
  
  @override
  Widget build(BuildContext context) { 

    final listaProvider = Provider.of<ListaProvider>(context);
    
    return Dismissible(
      key: UniqueKey(),
      background: Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              color: Colors.redAccent[700],
          ),
          
          child: Row(
            children: [
              SizedBox(width: 40.0,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Text("Eliminar", style: TextStyle(fontSize: 20.0),),
                     Icon(Icons.delete, size: 35.0,),
                  ],
              ),
            ],
          ),
        ),
      confirmDismiss: (direction) async {
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Desea eliminar el item?"),
                  title: Text("Confirmacion"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("NO")),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("SÍ")),
                  ],
                );
            } ,
          );
      },
      onDismissed: (direction) { 
           if(actividad.id != null) listaProvider.eliminarActividad(actividad.id!);
         },
      child: Card(
        
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: (actividad.activa==1)? style.colorCuadro : Colors.blueGrey, 
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
          child: ListTile(
                
                enabled: (actividad.activa==1)? true : false,             
                  title: Text(
                        actividad.titulo,
                        style: (actividad.activa==1)?style.estiloText1: style.estiloText3,
                  ),
                  subtitle: Text(actividad.descripcion, style: style.estiloText2,),
                  trailing: Column(
                    children: [
                      IconButton(
                        tooltip: "Realizado",
                        iconSize: 40.0,
                        onPressed: (){
                            if(actividad.id != null){
                                  (actividad.activa == 1) ? actividad.activa = 0 : actividad.activa = 1; 
                                  listaProvider.editarActividad(actividad);
                            } 
                              
                        },
                        icon: Icon(Icons.check, color: (actividad.activa==1)? Colors.white: Colors.orange,),
                      ),
                    ],
                  ),
                  onTap: () { 
                    if(actividad.id != null) _editarDescripcion(context);                
                  } ,
              ),
        ),
      ), 
    );
  } 

  Future<void> _editarDescripcion(BuildContext context) async { 

      final listaProvider = Provider.of<ListaProvider>(context, listen: false);
      
       return  showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                        children: [
                            TextFormField(
                              
                                
                                initialValue: actividad.descripcion,
                                onChanged: (t){
                            
                                    actividad.descripcion = t; 

                                },
                            )
                        ],
                    ),
                  ),
                  title: Text(actividad.titulo),
                  actions: [
                         TextButton(
                            onPressed: () {
                                listaProvider.editarActividad(actividad);
                                Navigator.of(context).pop(false); 
                            },
                            child: Text("Guardar"),
                      )
                  ],
                );
            } ,
          );
  }
}