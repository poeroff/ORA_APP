import json
import re
from asgiref.sync import async_to_sync
from django.views.decorators.csrf import csrf_exempt
import aiohttp # type: ignore
from django.http import JsonResponse, HttpResponse
import logging
import difflib
import os






    
    
def hello_world(request):
     return HttpResponse("Hello World");


