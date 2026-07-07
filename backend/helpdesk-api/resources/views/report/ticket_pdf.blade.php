<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Laporan Ticket</title>

    <style>

        body{
            font-family: DejaVu Sans;
            font-size:12px;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        table th,
        table td{
            border:1px solid #000;
            padding:8px;
        }

        h1{
            text-align:center;
        }

    </style>

</head>

<body>

<h1>E-Ticketing Helpdesk</h1>

<h3>Ringkasan</h3>

<p>Total : {{ $total }}</p>
<p>Done : {{ $done }}</p>
<p>Progress : {{ $progress }}</p>
<p>Open : {{ $open }}</p>

<br>

<table>

<tr>
<th>ID</th>
<th>Judul</th>
<th>Kategori</th>
<th>Status</th>
<th>Tanggal</th>
</tr>

@foreach($tickets as $ticket)

<tr>

<td>{{ $ticket->id }}</td>

<td>{{ $ticket->title }}</td>

<td>{{ $ticket->category }}</td>

<td>{{ $ticket->status }}</td>

<td>{{ $ticket->created_at }}</td>

</tr>

@endforeach

</table>

</body>

</html>
