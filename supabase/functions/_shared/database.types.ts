export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export type Database = {
  public: {
    Tables: {
      activity_segments: {
        Row: {
          end_location_id: string | null;
          id: string;
          start_location_id: string | null;
          user_id: string;
        };
        Insert: {
          end_location_id?: string | null;
          id?: string;
          start_location_id?: string | null;
          user_id: string;
        };
        Update: {
          end_location_id?: string | null;
          id?: string;
          start_location_id?: string | null;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "activity_segments_user_id_end_location_id_fkey";
            columns: ["user_id", "end_location_id"];
            isOneToOne: false;
            referencedRelation: "raw_location_data";
            referencedColumns: ["user_id", "id"];
          },
          {
            foreignKeyName: "activity_segments_user_id_fkey";
            columns: ["user_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "activity_segments_user_id_start_location_id_fkey";
            columns: ["user_id", "start_location_id"];
            isOneToOne: false;
            referencedRelation: "raw_location_data";
            referencedColumns: ["user_id", "id"];
          },
        ];
      };
      devices: {
        Row: {
          app_version: string;
          created_at: string;
          id: string;
          manufacturer: string;
          model: string;
          name: string;
          os_id: Database["public"]["Enums"]["operating_system"];
          os_version: string;
          updated_at: string;
          user_id: string;
        };
        Insert: {
          app_version: string;
          created_at: string;
          id?: string;
          manufacturer: string;
          model: string;
          name: string;
          os_id?: Database["public"]["Enums"]["operating_system"];
          os_version: string;
          updated_at: string;
          user_id: string;
        };
        Update: {
          app_version?: string;
          created_at?: string;
          id?: string;
          manufacturer?: string;
          model?: string;
          name?: string;
          os_id?: Database["public"]["Enums"]["operating_system"];
          os_version?: string;
          updated_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "devices_user_id_fkey";
            columns: ["user_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
        ];
      };
      public_info: {
        Row: {
          id: string;
          name: string;
          value: Json;
        };
        Insert: {
          id?: string;
          name: string;
          value: Json;
        };
        Update: {
          id?: string;
          name?: string;
          value?: Json;
        };
        Relationships: [];
      };
      raw_location_data: {
        Row: {
          activity_confidence: number;
          activity_type_id: Database["public"]["Enums"]["activity_type"];
          altitude_accuracy: number;
          battery_level: number;
          coordinates_accuracy: number;
          device_id: string;
          ellipsoidal_altitude: number;
          heading: number;
          heading_accuracy: number;
          id: string;
          is_device_charging: boolean;
          latitude: number;
          longitude: number;
          recording_trigger:
            Database["public"]["Enums"]["location_recording_trigger"];
          speed: number;
          speed_accuracy: number;
          timestamp: string;
          user_id: string;
        };
        Insert: {
          activity_confidence: number;
          activity_type_id?: Database["public"]["Enums"]["activity_type"];
          altitude_accuracy: number;
          battery_level: number;
          coordinates_accuracy: number;
          device_id: string;
          ellipsoidal_altitude: number;
          heading: number;
          heading_accuracy: number;
          id?: string;
          is_device_charging: boolean;
          latitude: number;
          longitude: number;
          recording_trigger?:
            Database["public"]["Enums"]["location_recording_trigger"];
          speed: number;
          speed_accuracy: number;
          timestamp: string;
          user_id: string;
        };
        Update: {
          activity_confidence?: number;
          activity_type_id?: Database["public"]["Enums"]["activity_type"];
          altitude_accuracy?: number;
          battery_level?: number;
          coordinates_accuracy?: number;
          device_id?: string;
          ellipsoidal_altitude?: number;
          heading?: number;
          heading_accuracy?: number;
          id?: string;
          is_device_charging?: boolean;
          latitude?: number;
          longitude?: number;
          recording_trigger?:
            Database["public"]["Enums"]["location_recording_trigger"];
          speed?: number;
          speed_accuracy?: number;
          timestamp?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "raw_location_data_user_id_device_id_fkey";
            columns: ["user_id", "device_id"];
            isOneToOne: false;
            referencedRelation: "devices";
            referencedColumns: ["user_id", "id"];
          },
          {
            foreignKeyName: "raw_location_data_user_id_fkey";
            columns: ["user_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
        ];
      };
      role_permissions: {
        Row: {
          id: string;
          permission: Database["public"]["Enums"]["permissions"];
          role: Database["public"]["Enums"]["roles"];
        };
        Insert: {
          id?: string;
          permission: Database["public"]["Enums"]["permissions"];
          role: Database["public"]["Enums"]["roles"];
        };
        Update: {
          id?: string;
          permission?: Database["public"]["Enums"]["permissions"];
          role?: Database["public"]["Enums"]["roles"];
        };
        Relationships: [];
      };
      user_roles: {
        Row: {
          accepted_at: string | null;
          created_at: string;
          deleted_at: string | null;
          id: string;
          invited_at: string;
          role: Database["public"]["Enums"]["roles"];
          updated_at: string;
          user_id: string;
        };
        Insert: {
          accepted_at?: string | null;
          created_at?: string;
          deleted_at?: string | null;
          id?: string;
          invited_at?: string;
          role: Database["public"]["Enums"]["roles"];
          updated_at?: string;
          user_id: string;
        };
        Update: {
          accepted_at?: string | null;
          created_at?: string;
          deleted_at?: string | null;
          id?: string;
          invited_at?: string;
          role?: Database["public"]["Enums"]["roles"];
          updated_at?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "user_roles_user_id_fkey";
            columns: ["user_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
        ];
      };
      users: {
        Row: {
          created_at: string;
          deleted_at: string | null;
          email: string;
          id: string;
          updated_at: string;
          username: string;
        };
        Insert: {
          created_at?: string;
          deleted_at?: string | null;
          email: string;
          id: string;
          updated_at?: string;
          username: string;
        };
        Update: {
          created_at?: string;
          deleted_at?: string | null;
          email?: string;
          id?: string;
          updated_at?: string;
          username?: string;
        };
        Relationships: [];
      };
      visits: {
        Row: {
          arrival_location_id: string | null;
          departure_location_id: string | null;
          id: string;
          name: string;
          user_id: string;
        };
        Insert: {
          arrival_location_id?: string | null;
          departure_location_id?: string | null;
          id?: string;
          name: string;
          user_id: string;
        };
        Update: {
          arrival_location_id?: string | null;
          departure_location_id?: string | null;
          id?: string;
          name?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: "visits_user_id_arrival_location_id_fkey";
            columns: ["user_id", "arrival_location_id"];
            isOneToOne: false;
            referencedRelation: "raw_location_data";
            referencedColumns: ["user_id", "id"];
          },
          {
            foreignKeyName: "visits_user_id_departure_location_id_fkey";
            columns: ["user_id", "departure_location_id"];
            isOneToOne: false;
            referencedRelation: "raw_location_data";
            referencedColumns: ["user_id", "id"];
          },
          {
            foreignKeyName: "visits_user_id_fkey";
            columns: ["user_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
        ];
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      has_permission: {
        Args: {
          requested_permission: Database["public"]["Enums"]["permissions"];
        };
        Returns: boolean;
      };
    };
    Enums: {
      activity_type:
        | "still"
        | "walking"
        | "on_foot"
        | "running"
        | "on_bicycle"
        | "in_vehicle"
        | "unknown";
      location_recording_trigger: "standard" | "significant_change";
      operating_system:
        | "android"
        | "ios"
        | "windows"
        | "linux"
        | "macos"
        | "web"
        | "unknown";
      permissions: "read.users" | "write.users";
      roles: "admin" | "member";
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">;

type DefaultSchema =
  DatabaseWithoutInternals[Extract<keyof Database, "public">];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  } ? keyof (
      & DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
        "Tables"
      ]
      & DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
        "Views"
      ]
    )
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
} ? (
    & DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
      "Tables"
    ]
    & DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
      "Views"
    ]
  )[TableName] extends {
    Row: infer R;
  } ? R
  : never
  : DefaultSchemaTableNameOrOptions extends keyof (
    & DefaultSchema["Tables"]
    & DefaultSchema["Views"]
  ) ? (
      & DefaultSchema["Tables"]
      & DefaultSchema["Views"]
    )[DefaultSchemaTableNameOrOptions] extends {
      Row: infer R;
    } ? R
    : never
  : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  } ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
      "Tables"
    ]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
} ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
    "Tables"
  ][TableName] extends {
    Insert: infer I;
  } ? I
  : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
      Insert: infer I;
    } ? I
    : never
  : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  } ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
      "Tables"
    ]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
} ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]][
    "Tables"
  ][TableName] extends {
    Update: infer U;
  } ? U
  : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
      Update: infer U;
    } ? U
    : never
  : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  } ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]][
      "Enums"
    ]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
} ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][
    EnumName
  ]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
  : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  } ? keyof DatabaseWithoutInternals[
      PublicCompositeTypeNameOrOptions["schema"]
    ]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
} ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]][
    "CompositeTypes"
  ][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends
    keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
  : never;

export const Constants = {
  public: {
    Enums: {
      activity_type: [
        "still",
        "walking",
        "on_foot",
        "running",
        "on_bicycle",
        "in_vehicle",
        "unknown",
      ],
      location_recording_trigger: ["standard", "significant_change"],
      operating_system: [
        "android",
        "ios",
        "windows",
        "linux",
        "macos",
        "web",
        "unknown",
      ],
      permissions: ["read.users", "write.users"],
      roles: ["admin", "member"],
    },
  },
} as const;
