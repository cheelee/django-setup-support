from django.contrib.auth import get_user_model
from rest_framework import authentication

User = get_user_model()

# Always authenticate as the superuser for the REST API in development debug mode
class DevAuthentication(authentication.BasicAuthentication):
    def authenticate(self, request):
        qs = User.objects.filter(id=1)
        user = qs.order_by("?").first()
        return (user, None)