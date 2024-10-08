"""
ASGI config for ora_python_back project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/howto/deployment/asgi/
"""

import os
from django.urls import path
from django.core.asgi import get_asgi_application
from ora_python_back import ai

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ora_python_back.settings')

application = get_asgi_application()

urlpatterns = [
    path('start_conversation/', ai.start_conversation),
]
