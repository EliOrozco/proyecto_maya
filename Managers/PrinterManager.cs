using Godot;
using System;

public partial class PrinterManager : Node
{
	public string[] ticket_list;
	public float money_received;
	public float money_change;
	public float ticket_total;
	public string ticket_number;
	public string ticket_list_string;

	public override void _Ready()
	{
		GD.Print("Conector con la impresora está listo");
	}

	public void ConectToPrinter()
	{
		ticket_list_string = Convert.ToString(ticket_list);
		GD.Print("Tu ticket es:" + ticket_number +  " / TOTAL: " + ticket_total + " / RECIBIDO: " + money_received + " / CAMBIO: " + money_change + " / DETALLES: ");
		GD.Print(ticket_list);
	}
}
