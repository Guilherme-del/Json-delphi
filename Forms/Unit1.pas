unit Unit1;

interface

  uses
    System.SysUtils, System.Types, System.UITypes, System.Classes,
    System.Variants,
    FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
    FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
    System.JSON;

  type
    TForm1 = class(TForm)
      Layout1: TLayout;
      Memo1: TMemo;
      Button1: TButton;
      Button2: TButton;
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      private
        { Private declarations }
      public
        { Public declarations }
    end;

  var
    Form1: TForm1;

implementation

  {$R *.fmx}

  procedure TForm1.Button1Click(Sender: TObject);
    var
      jsonObjPed, jsonObjItem: TJSONObject;
      jsonArrayItem, jsonArrayPed: TJSONArray;
      x, y: integer;
    begin
      try
        jsonArrayPed := TJSONArray.Create;

        // Pedidos...
        for x := 1 to 2 do
          begin
            jsonObjPed := TJSONObject.Create;
            jsonObjPed.AddPair('pedido', x.ToString);
            jsonObjPed.AddPair('cliente', 'Teste');
            jsonObjPed.AddPair('total', TJSONNumber.Create(500.25));
            jsonObjPed.AddPair('pendente', TJSONBool.Create(true));

            // Itens...
            jsonArrayItem := TJSONArray.Create;

            for y := 1 to 2 do
              begin
                jsonObjItem := TJSONObject.Create;
                jsonObjItem.AddPair('produto', y.ToString);
                jsonObjItem.AddPair('descricao', 'Produto ' + y.ToString);
                jsonObjItem.AddPair('qtd', TJSONNumber.Create(y));

                jsonArrayItem.AddElement(jsonObjItem);
              end;

            jsonObjPed.AddPair('itens', jsonArrayItem);

            jsonArrayPed.AddElement(jsonObjPed);
          end;

        Memo1.Lines.Add(jsonArrayPed.ToString);

      finally
        jsonArrayPed.DisposeOf;
      end;
    end;

  procedure TForm1.Button2Click(Sender: TObject);
    var
      ArrayPed, ArrayItem: TJSONArray;
      JSON: string;
      x, j: integer;
    begin
      JSON := Memo1.Lines.Text; // WS...

      ArrayPed := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0)
        as TJSONArray;

      for x := 0 to ArrayPed.Size - 1 do
        begin

          Memo1.Lines.Add('Pedido:' + ArrayPed.Get(x)
              .GetValue<integer>('pedido', 0).ToString);
          Memo1.Lines.Add('Cliente:' + ArrayPed.Get(x)
              .GetValue<string>('cliente', ''));
          Memo1.Lines.Add('Total:' + ArrayPed.Get(x).GetValue<double>('total',
              0).ToString);

          ArrayItem := ArrayPed.Get(x).GetValue<TJSONArray>('itens');

          for j := 0 to ArrayItem.Size - 1 do
            begin
              Memo1.Lines.Add('Produto:' + ArrayItem.Get(j)
                  .GetValue<string>('produto', ''));
              Memo1.Lines.Add('Qtd:' + ArrayItem.Get(j).GetValue<integer>('qtd',
                  0).ToString);
            end;

        end;
      ArrayPed.DisposeOf;

    end;

end.
