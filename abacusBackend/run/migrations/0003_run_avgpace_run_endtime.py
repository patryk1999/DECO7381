# Generated by Django 4.2.4 on 2023-09-20 05:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('run', '0002_alter_run_concurrentrun_alter_run_starttime'),
    ]

    operations = [
        migrations.AddField(
            model_name='run',
            name='avgPace',
            field=models.FloatField(null=True),
        ),
        migrations.AddField(
            model_name='run',
            name='endTime',
            field=models.DateTimeField(null=True),
        ),
    ]
