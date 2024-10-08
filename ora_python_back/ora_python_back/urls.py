"""
URL configuration for ora_python_back project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.views.decorators.http import require_http_methods
from ora_python_back import ai
from asgiref.sync import async_to_sync


urlpatterns = [
    path("",ai.hello_world),
    path('/admin/', admin.site.urls),
    path("/get_data_from_db/", ai.get_data_from_db),
    path('/start_conversation/', ai.start_conversation)
]
