<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class HelpdeskController extends Controller
{

    public function index()
    {
        return User::where('role', 'helpdesk')
            ->orderBy('name')
            ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:100',
            'username' => 'required|max:50|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'phone' => 'nullable|max:20',
            'password' => 'required|min:6',
        ]);

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'role' => 'helpdesk',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Helpdesk berhasil ditambahkan',
            'data' => $user
        ],201);
    }

    public function show($id)
    {
        return User::where('role','helpdesk')
            ->findOrFail($id);
    }

    public function update(Request $request,$id)
    {
        $user = User::findOrFail($id);

        $request->validate([
            'name'=>'required|max:100',
            'email'=>'required|email|unique:users,email,'.$id,
            'phone'=>'nullable|max:20',
        ]);

        $user->update([
            'name'=>$request->name,
            'email'=>$request->email,
            'phone'=>$request->phone,
        ]);

        if($request->filled('password')){
            $user->password = Hash::make($request->password);
            $user->save();
        }

        return response()->json([
            'success'=>true,
            'message'=>'Helpdesk berhasil diupdate',
            'data'=>$user
        ]);
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);

        $user->delete();

        return response()->json([
            'success'=>true,
            'message'=>'Helpdesk berhasil dihapus'
        ]);
    }
}
