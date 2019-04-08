from django.db import models
from django.forms import ModelForm
from django.utils.translation import gettext_lazy as _

# Create your models here.

class DummyModel(models.Model):
    desc = models.CharField(max_length=128, blank=False, null=False);

class DummyForm(ModelForm):
    class Meta:
        model = DummyModel;
        fields = [
            'desc',
            ];
        labels = {
            'desc':_('Description'),
            };
