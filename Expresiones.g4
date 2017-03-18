grammar Expresiones;
@parser::header
{
	import com.automatas.PatronInterprete.AST.*;       
	import java.util.List;	                    //importamos las librerias hashmap para referenciar 
	import java.util.HashMap;
	import java.util.Map;
}

miprograma: LLAVE_A {
	List<ASTNodo> sentencias_programa = new ArrayList<ASTNodo>();   //creamos una lista tipo ASTNodo para insertar todos las sentencias 
	new ArrayList<ASTNodo>();                                       
	Map<String,Object> symbolTable= new HashMap<String,Object>();   //Ccreacion del hashmap para referenciar los valores
}
LLAVE_A
    (
    sentencias                          
	{
	sentencias_programa.add($sentencias.nodo_sentencias);          //Aqui agregamos en la lista $ referencia a sentencias el cual es tipo ASTNodo 
    })*                                                            // El cual pueden ser muchas por "*" que indica que es klean 
LLAVE_C
    {
	for(ASTNodo n: sentencias_programa)                             
	n.ejecutar(symbolTable);
    } LLAVE_C;



sentencias returns [ASTNodo nodo_sentencias]:
		imprimir                                                    //sentencias imprime o puedes declarar una variable
		{
			$nodo_sentencias=$imprimir.nodo_impresion; 
		}
			|
		declaracion_variable{
			$nodo_sentencias = $declaracion_variable.nodo_declaracion;
		}
;		

		
declaracion_variable returns [ASTNodo nodo_declaracion]:            //puede ser una declaracion de variable
    cuerpo_declaracion SEMI 
    {
	$nodo_declaracion = new DeclaracionVariable($nodo_declaracion.cuerpo_declaracion);  //int variable;
    };

cuerpo_declaracion returns [ASTNodo nodo_cuerpo]:
    tipos_variables contenido_declaracion{
	$nodo_cuerpo= new DeclaracionVariable($nodo_cuerpo.contenido_declaracion);      //  o declaracion con valor int i = 69;
    };

contenido_declaracion returns [ASTNodo nodo_contenido]:
    ID 
    {
	$nodo_contenido = new DeclaracionVariable($ID.text);
    } 
	|
ID IGUAL expresion
    {
	$nodo_contenido = new DeclaracionVariable($ID.text,$expresion.nodo_exp);
	
}
;


tipos_variables:
	STRING | INT | FLOAT;

imprimir returns [ASTNodo nodo_impresion]:                              // impresion de la variable o valor que recibimos 
			 IMPRIMIR PARENTESIS_AB expresion PARENTESIS_CE SEMI {
				$nodo_impresion=new Imprimir($expresion.nodo_exp);
			}
			;

expresion returns [ASTNodo nodo_exp]: 
			f1 = factor
			{
				$nodo_exp = $f1.nodo_factor;
			}                                                  //una expresion puede ser un mas o un menos o puede ser un factor multiplicando o dividiendo
			(MAS f2 = factor
				{
					$nodo_exp = new Suma($nodo_exp,$f2.nodo_factor);
				}
			|
			MENOS f2 = factor
				{
					$nodo_exp = new Menos($nodo_exp,$f2.nodo_factor);
				}
			)*
			;

factor returns [ASTNodo nodo_factor]: 
			t1 = termino
			{
				$nodo_factor = $t1.nodo_termino;
			} 
			(POR t2 = termino
				{
					$nodo_factor = new Multiplicar($nodo_factor,$t2.nodo_termino);
				}
				|
			  DIVISION t2 = termino{
			  	$nodo_factor = new Division($nodo_factor,$t2.nodo_termino);
			  }
			  |
				POTENCIA t2= termino{
					$nodo_factor = new Potencia($nodo_factor,$t2.nodo_termino);
			})*
			;

termino returns [ASTNodo nodo_termino]: 
		   NUMERO                                                               //Aqui indicamos si es numero o es una variable
			{
				$nodo_termino = new Constante(Double.parseDouble($NUMERO.text));
			}
			|
		    ID {
				$nodo_termino = new VariableReferencia($ID.text);
				
			}
			|
			PARENTESIS_AB expresion PARENTESIS_CE
			;

/****************************************************TOKENS *******************************************************************/
NUMERO:('0'..'9')+;
MAS:'+';
MENOS:'-';
POR:'*';
POTENCIA:'^';
DIVISION:'/';
PUBLICO:'public';
CLASS:'class';
STATIC:'static';
VOID:'void';
MAIN:'main';
ARG:'arg';
IMPRIMIR:'System.out.print';
LLAVE_A:'{';
LLAVE_C:'}';
MAYOR:'>';
MENOR:'<';
MAYORIGUAL:'>=';
MENORIGUAL:'<=';
IGUALA:'==';
DIFERENTEIGUAL:'!=';
IGUAL:'=';
IF:'if';
ELSE:'else';
WHILE:'while';
FOR:'for';
PARENTESIS_AB:'(';
PARENTESIS_CE:')';
CORCHETE_AB:'[';
CORCHETE_CE:']';
SEMI:';';
INT:'int';
STRING:'String';
FLOAT:'float';
PAQUETE:'package';
IMPORTAR:'import';
PUNTO:'.';
ID:[A-Za-z_]+;
WS:[ \t\r\n]+ -> skip;
