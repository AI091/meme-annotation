create table "public"."annotations" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "image_url" text not null,
    "text" text,
    "annoatation" jsonb,
    "annotated" boolean not null default false
);


CREATE UNIQUE INDEX annotations_pkey ON public.annotations USING btree (id);

alter table "public"."annotations" add constraint "annotations_pkey" PRIMARY KEY using index "annotations_pkey";

grant delete on table "public"."annotations" to "anon";

grant insert on table "public"."annotations" to "anon";

grant references on table "public"."annotations" to "anon";

grant select on table "public"."annotations" to "anon";

grant trigger on table "public"."annotations" to "anon";

grant truncate on table "public"."annotations" to "anon";

grant update on table "public"."annotations" to "anon";

grant delete on table "public"."annotations" to "authenticated";

grant insert on table "public"."annotations" to "authenticated";

grant references on table "public"."annotations" to "authenticated";

grant select on table "public"."annotations" to "authenticated";

grant trigger on table "public"."annotations" to "authenticated";

grant truncate on table "public"."annotations" to "authenticated";

grant update on table "public"."annotations" to "authenticated";

grant delete on table "public"."annotations" to "service_role";

grant insert on table "public"."annotations" to "service_role";

grant references on table "public"."annotations" to "service_role";

grant select on table "public"."annotations" to "service_role";

grant trigger on table "public"."annotations" to "service_role";

grant truncate on table "public"."annotations" to "service_role";

grant update on table "public"."annotations" to "service_role";


