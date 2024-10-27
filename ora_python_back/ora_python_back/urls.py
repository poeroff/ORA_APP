from django.urls import path
from ora_python_back import ai

urlpatterns = [
    path("get_data_from_db", ai.get_data_from_db),
    path('start_program', ai.start_program)
]
