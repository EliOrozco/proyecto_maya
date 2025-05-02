using Godot;
using System;
using System.Collections.Generic;

public partial class PrinterManager : Node
{
	public Godot.Collections.Array<Godot.Collections.Dictionary<string, string>> ticket_list;
	/* Los elementos del diccionario son los siguientes:
	{ 
		"nombre_producto" : productBigName,
		"tipo" : productText,
		"cantidad" : cantidadSelected,
		"modificadores" : optionsSelectedNames,
		"precio_sin_modificadores" : productPrice,
		"precio_final" : productFinalPrice
	}
	*/
	public float money_received;
	public float money_change;
	public float ticket_total;
	public string ticket_number;

	public override void _Ready()
	{
		GD.Print("Conector con la impresora está listo");
	}

	public void ConectToPrinter()
	{
		GD.Print("--------------------------");
		GD.Print("Tu ticket es:" + ticket_number +  " / TOTAL: " + ticket_total + " / RECIBIDO: " + money_received + " / CAMBIO: " + money_change + " / DETALLES: ");
		
		foreach (var dict in ticket_list)
		{
			GD.Print("------");
			foreach (string key in dict.Keys)
			{
				GD.Print($"{key} : {dict[key]}");
			}
		}
	}
}
