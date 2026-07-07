<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\TicketController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\HelpdeskController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/profile/{id}', [AuthController::class, 'profile']);
Route::put('/profile/{id}', [AuthController::class, 'updateProfile']);
Route::put('/change-password/{id}', [AuthController::class, 'changePassword']);

Route::get('/dashboard/statistics', [TicketController::class, 'statistics']);
Route::get('/dashboard/weekly', [TicketController::class, 'weekly']);
Route::put('/tickets/{ticket}/status', [TicketController::class, 'updateStatus']);

Route::get('/report/weekly',[TicketController::class,'reportWeekly']);

Route::get('/report/done',[TicketController::class,'reportDone']);

Route::get('/report/helpdesk',[TicketController::class,'reportHelpdesk']);
Route::get('/report/pdf',[TicketController::class,'exportPdf']);

Route::apiResource('helpdesks', HelpdeskController::class);
Route::apiResource('notifications', NotificationController::class);
Route::apiResource('tickets', TicketController::class);
