<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Ticket;
use App\Models\Notification;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Barryvdh\DomPDF\Facade\Pdf;

class TicketController extends Controller
{
    public function index()
    {
        return Ticket::latest()->get();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'category' => 'required|string',
            'priority' => 'required|string',
            'status' => 'required|string',
        ]);

        $ticket = Ticket::create($validated);

        Notification::create([
            'title' => 'Tiket Baru',
            'message' => 'Tiket "' . $ticket->title . '" berhasil dibuat.',
            'type' => 'create',
            'role' => 'admin',
        ]);

        return response()->json([
            'message' => 'Ticket berhasil dibuat',
            'data' => $ticket
        ], 201);
    }

    public function show(Ticket $ticket)
    {
        return $ticket;
    }

    public function update(Request $request, Ticket $ticket)
    {
        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'category' => 'sometimes|string',
            'priority' => 'sometimes|string',
            'status' => 'sometimes|string',
            'assigned_to' => 'sometimes|integer|nullable',
        ]);

        $ticket->update($validated);

        if ($request->has('assigned_to')) {

            Notification::create([
                'title' => 'Tiket Diassign',
                'message' => 'Tiket "' . $ticket->title . '" telah diassign.',
                'type' => 'assign',
                'role' => 'helpdesk',
            ]);

        }

        if ($request->has('status')) {

            Notification::create([
                'title' => 'Status Tiket',
                'message' => 'Status tiket "' . $ticket->title . '" menjadi ' . $ticket->status,
                'type' => 'status',
                'role' => 'user',
            ]);

        }

        return response()->json([
            'message' => 'Ticket berhasil diupdate',
            'data' => $ticket,
        ]);
    }

    public function destroy(Ticket $ticket)
    {
        Notification::create([
            'title' => 'Tiket Dihapus',
            'message' => 'Tiket "' . $ticket->title . '" telah dihapus.',
            'type' => 'delete',
            'role' => 'admin',
        ]);

        $ticket->delete();

        return response()->json([
            'message' => 'Ticket berhasil dihapus'
        ]);
    }

    public function statistics()
    {
        return response()->json([
            'total' => Ticket::count(),
            'open' => Ticket::where('status', 'Open')->count(),
            'progress' => Ticket::where('status', 'Progress')->count(),
            'done' => Ticket::where('status', 'Done')->count(),
        ]);
    }

    public function updateStatus(Request $request, Ticket $ticket)
    {
        $request->validate([
            'status' => 'required|string',
        ]);

        $ticket->update([
            'status' => $request->status,
        ]);

        return response()->json([
            'message' => 'Status berhasil diubah',
            'data' => $ticket,
        ]);
    }

    public function weekly()
    {
        $data = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::now()->subDays($i);
            $count = Ticket::whereDate('created_at', $date)->count();
            $data[] = [
                "day" => $date->translatedFormat("D"),
                "count" => $count,
            ];
        }

        return response()->json($data);
    }

    public function reportWeekly()
    {
        return response()->json([
            "total" => Ticket::count(),
            "done" => Ticket::where('status','Done')->count(),
            "progress" => Ticket::where('status','Progress')->count(),
            "open" => Ticket::where('status','Open')->count(),

            "tickets" => Ticket::latest()
                ->take(10)
                ->get([
                    'id',
                    'title',
                    'status',
                    'category',
                    'created_at'
                ]),
        ]);
    }

    public function reportDone()
    {
        return Ticket::where('status','Done')
            ->latest()
            ->get([
                'id',
                'title',
                'category',
                'priority',
                'created_at'
            ]);
    }

    public function reportHelpdesk()
    {
        return Ticket::selectRaw("
            assigned_to,
            COUNT(*) as total,
            SUM(status='Done') as done,
            SUM(status='Progress') as progress
        ")
        ->groupBy('assigned_to')
        ->get();
    }

    public function exportPdf()
    {
        $tickets = Ticket::latest()->get();

        $total = Ticket::count();
        $done = Ticket::where('status','Done')->count();
        $progress = Ticket::where('status','Progress')->count();
        $open = Ticket::where('status','Open')->count();

        $pdf = Pdf::loadView('report.ticket_pdf', [
            'tickets' => $tickets,
            'total' => $total,
            'done' => $done,
            'progress' => $progress,
            'open' => $open,
        ]);

        return $pdf->download('Laporan_Tiket.pdf');
    }
}
