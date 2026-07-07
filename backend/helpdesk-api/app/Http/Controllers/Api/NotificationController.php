<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    // Ambil semua notifikasi
    public function index()
    {
        return Notification::latest()->get();
    }

    // Tambah notifikasi
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'type' => 'required|string',
            'role' => 'required|string',
        ]);

        $notification = Notification::create($validated);

        return response()->json([
            'message' => 'Notifikasi berhasil dibuat',
            'data' => $notification,
        ], 201);
    }

    // Detail notifikasi
    public function show(string $id)
    {
        return Notification::findOrFail($id);
    }

    // Update notifikasi
    public function update(Request $request, string $id)
    {
        $notification = Notification::findOrFail($id);

        $notification->update([
            'title' => $request->title ?? $notification->title,
            'message' => $request->message ?? $notification->message,
            'type' => $request->type ?? $notification->type,
            'role' => $request->role ?? $notification->role,
            'is_read' => $request->is_read ?? $notification->is_read,
        ]);

        return response()->json([
            'message' => 'Notifikasi berhasil diupdate',
            'data' => $notification,
        ]);
    }

    // Hapus notifikasi
    public function destroy(string $id)
    {
        Notification::findOrFail($id)->delete();

        return response()->json([
            'message' => 'Notifikasi berhasil dihapus',
        ]);
    }
}
